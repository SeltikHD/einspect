import 'dart:async';

import 'package:einspect/core/routing/app_router.dart';
import 'package:einspect/core/widgets/app_filter_chip.dart';
import 'package:einspect/core/widgets/offline_banner.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_event.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_state.dart';
import 'package:einspect/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:einspect/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:einspect/features/work_orders/presentation/bloc/work_orders_state.dart';
import 'package:einspect/features/work_orders/presentation/ui/widgets/work_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage({super.key});

  String _getUserId(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    return state is Authenticated ? state.user.id : '';
  }

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<WorkOrdersBloc>().add(
      WorkOrdersFetchRequested(
        userId: _getUserId(context),
        completer: completer,
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final userId = _getUserId(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Serviço'),
        actions: [
          PopupMenuButton<WorkOrderSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordenar por',
            onSelected: (sort) {
              context.read<WorkOrdersBloc>().add(
                WorkOrdersFilterChanged(sort: sort),
              );
            },
            itemBuilder: (context) {
              final onSurface = Theme.of(context).colorScheme.onSurface;

              return [
                const PopupMenuItem(
                  value: WorkOrderSort.urgent,
                  child: Row(
                    children: [
                      Icon(Icons.priority_high, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Mais urgentes'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: WorkOrderSort.newest,
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: onSurface, size: 18),
                      const SizedBox(width: 8),
                      const Text('Mais recentes'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: WorkOrderSort.scheduled,
                  child: Row(
                    children: [
                      Icon(Icons.event, color: onSurface, size: 18),
                      const SizedBox(width: 8),
                      const Text('Data agendada'),
                    ],
                  ),
                ),
              ];
            },
          ),
          IconButton(
            tooltip: 'Histórico de Inspeções',
            icon: const Icon(Icons.history),
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed(AppRoutes.inspectionsHistory, arguments: userId);
              if (context.mounted) unawaited(_refresh(context));
            },
          ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),

          // Filter topbar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
              builder: (context, state) {
                final currentStatus = switch (state) {
                  final WorkOrdersSuccess s => s.activeStatus,
                  final WorkOrdersEmpty e => e.activeStatus,
                  _ => null,
                };

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppFilterChip(
                        label: 'Todas',
                        isSelected: currentStatus == null,
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(statusFilter: 'ALL'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Abertas',
                        isSelected: currentStatus == 'open',
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(statusFilter: 'open'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Em Andamento',
                        isSelected: currentStatus == 'in_progress',
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(
                            statusFilter: 'in_progress',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppFilterChip(
                        label: 'Concluídas',
                        isSelected: currentStatus == 'done',
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(statusFilter: 'done'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // List content
          Expanded(
            child: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
              builder: (context, state) {
                if (state is WorkOrdersLoading || state is WorkOrdersInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WorkOrdersError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 56,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _refresh(context),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is WorkOrdersEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 140),
                        const Icon(
                          Icons.filter_list_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Nenhuma ordem de serviço neste filtro.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.paddingOf(context).bottom + 16,
                        ),
                      ],
                    ),
                  );
                }

                if (state is WorkOrdersSuccess) {
                  return RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: MediaQuery.paddingOf(context).bottom + 16,
                      ),
                      itemCount: state.workOrders.length,
                      itemBuilder: (context, index) {
                        final workOrder = state.workOrders[index];
                        final inspectionStatus =
                            state.inspectionStatuses[workOrder.id];

                        return WorkOrderCard(
                          workOrder: workOrder,
                          localInspectionStatus: inspectionStatus,
                          onTap: () async {
                            await Navigator.of(context).pushNamed(
                              AppRoutes.inspectionForm,
                              arguments: (workOrder: workOrder, userId: userId),
                            );
                            if (context.mounted) unawaited(_refresh(context));
                          },
                        );
                      },
                    ),
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
