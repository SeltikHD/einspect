import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_filter_chip.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/inspection_entity.dart';
import '../bloc/history/inspections_history_bloc.dart';
import '../bloc/history/inspections_history_event.dart';
import '../bloc/history/inspections_history_state.dart';
import 'widgets/inspection_history_card.dart';

class InspectionsHistoryPage extends StatelessWidget {
  const InspectionsHistoryPage({super.key});

  String _getUserId(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    return state is Authenticated ? state.user.id : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fila de Inspeções'),
        actions: [
          BlocBuilder<InspectionsHistoryBloc, InspectionsHistoryState>(
            builder: (context, state) {
              final isSyncing =
                  state is InspectionsHistorySuccess && state.isSyncing;

              return IconButton(
                tooltip: 'Sincronizar Agora',
                icon: isSyncing
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.sync),
                onPressed: isSyncing
                    ? null
                    : () => context.read<InspectionsHistoryBloc>().add(
                        const InspectionsManualSyncRequested(),
                      ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter status selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<InspectionsHistoryBloc, InspectionsHistoryState>(
              builder: (context, state) {
                final currentFilter = state is InspectionsHistorySuccess
                    ? state.activeFilter
                    : null;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppFilterChip(
                        label: 'Todas',
                        isSelected: currentFilter == null,
                        onSelected: () {
                          final authState = context.read<AuthBloc>().state;
                          final currentUserId = authState is Authenticated
                              ? authState.user.id
                              : '';

                          context.read<InspectionsHistoryBloc>().add(
                            InspectionsHistoryFetchRequested(
                              userId: currentUserId,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Rascunhos',
                        isSelected: currentFilter == InspectionStatus.draft,
                        onSelected: () {
                          final authState = context.read<AuthBloc>().state;
                          final currentUserId = authState is Authenticated
                              ? authState.user.id
                              : '';

                          context.read<InspectionsHistoryBloc>().add(
                            InspectionsHistoryFetchRequested(
                              userId: currentUserId,
                              statusFilter: InspectionStatus.draft,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Pendentes',
                        isSelected: currentFilter == InspectionStatus.pending,
                        onSelected: () {
                          final authState = context.read<AuthBloc>().state;
                          final currentUserId = authState is Authenticated
                              ? authState.user.id
                              : '';
                          context.read<InspectionsHistoryBloc>().add(
                            InspectionsHistoryFetchRequested(
                              userId: currentUserId,
                              statusFilter: InspectionStatus.pending,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Sincronizadas',
                        isSelected: currentFilter == InspectionStatus.synced,
                        onSelected: () {
                          final authState = context.read<AuthBloc>().state;
                          final currentUserId = authState is Authenticated
                              ? authState.user.id
                              : '';

                          context.read<InspectionsHistoryBloc>().add(
                            InspectionsHistoryFetchRequested(
                              userId: currentUserId,
                              statusFilter: InspectionStatus.synced,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Falhas',
                        isSelected: currentFilter == InspectionStatus.failed,
                        onSelected: () {
                          final authState = context.read<AuthBloc>().state;
                          final currentUserId = authState is Authenticated
                              ? authState.user.id
                              : '';

                          context.read<InspectionsHistoryBloc>().add(
                            InspectionsHistoryFetchRequested(
                              userId: currentUserId,
                              statusFilter: InspectionStatus.failed,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Inspection list presentation
          Expanded(
            child: BlocBuilder<InspectionsHistoryBloc, InspectionsHistoryState>(
              builder: (context, state) {
                if (state is InspectionsHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InspectionsHistoryError) {
                  return Center(child: Text(state.message));
                }

                if (state is InspectionsHistorySuccess) {
                  if (state.inspections.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma inspeção nesta categoria.'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.inspections.length,
                    itemBuilder: (context, index) {
                      final item = state.inspections[index];
                      return InspectionHistoryCard(
                        inspection: item,
                        onRetry: item.status == InspectionStatus.failed
                            ? () => context.read<InspectionsHistoryBloc>().add(
                                InspectionRetryRequested(
                                  clientId: item.clientId,
                                  userId: _getUserId(context),
                                ),
                              )
                            : null,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
