import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/inspection_entity.dart';
import '../bloc/history/inspections_history_bloc.dart';
import '../bloc/history/inspections_history_event.dart';
import '../bloc/history/inspections_history_state.dart';
import 'widgets/inspection_history_card.dart';

class InspectionsHistoryPage extends StatelessWidget {
  const InspectionsHistoryPage({super.key});

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
                      _FilterChip(
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
                      _FilterChip(
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
                      _FilterChip(
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
                      _FilterChip(
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
                      _FilterChip(
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
                                InspectionRetryRequested(item.clientId),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF0072CE),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF0B1E36),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
