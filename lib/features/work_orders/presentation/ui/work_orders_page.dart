import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../inspections/presentation/bloc/form/inspection_form_bloc.dart';
import '../../../inspections/presentation/bloc/form/inspection_form_event.dart';
import '../../../inspections/presentation/bloc/history/inspections_history_bloc.dart';
import '../../../inspections/presentation/bloc/history/inspections_history_event.dart';
import '../../../inspections/presentation/ui/inspection_form_page.dart';
import '../../../inspections/presentation/ui/inspections_history_page.dart';
import '../bloc/work_orders_bloc.dart';
import '../bloc/work_orders_event.dart';
import '../bloc/work_orders_state.dart';
import 'widgets/work_order_card.dart';

class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage({super.key});

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<WorkOrdersBloc>().add(
      WorkOrdersFetchRequested(completer: completer),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
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
            itemBuilder: (context) => const [
              PopupMenuItem(
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
                    Icon(Icons.access_time, size: 18),
                    SizedBox(width: 8),
                    Text('Mais recentes'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: WorkOrderSort.scheduled,
                child: Row(
                  children: [
                    Icon(Icons.event, size: 18),
                    SizedBox(width: 8),
                    Text('Data agendada'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Histórico de Inspeções',
            icon: const Icon(Icons.history),
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              final currentUserId = authState is Authenticated
                  ? authState.user.id
                  : '';

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => sl<InspectionsHistoryBloc>()
                      ..add(
                        InspectionsHistoryFetchRequested(userId: currentUserId),
                      ),
                    child: const InspectionsHistoryPage(),
                  ),
                ),
              );
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
          // Fitler topbar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
              builder: (context, state) {
                final currentStatus = switch (state) {
                  WorkOrdersSuccess s => s.activeStatus,
                  WorkOrdersEmpty e => e.activeStatus,
                  _ => null,
                };

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChipItem(
                        label: 'Todas',
                        isSelected: currentStatus == null,
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(statusFilter: 'ALL'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipItem(
                        label: 'Abertas',
                        isSelected: currentStatus == 'open',
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(statusFilter: 'open'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipItem(
                        label: 'Em Andamento',
                        isSelected: currentStatus == 'in_progress',
                        onSelected: () => context.read<WorkOrdersBloc>().add(
                          const WorkOrdersFilterChanged(
                            statusFilter: 'in_progress',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipItem(
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
                            onPressed: () => context.read<WorkOrdersBloc>().add(
                              const WorkOrdersFetchRequested(),
                            ),
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
                      children: const [
                        SizedBox(height: 140),
                        Icon(
                          Icons.filter_list_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Nenhuma ordem de serviço neste filtro.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is WorkOrdersSuccess) {
                  return RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.workOrders.length,
                      itemBuilder: (context, index) {
                        final workOrder = state.workOrders[index];
                        return WorkOrderCard(
                          workOrder: workOrder,
                          onTap: () {
                            final authState = context.read<AuthBloc>().state;
                            final currentUserId = authState is Authenticated
                                ? authState.user.id
                                : '';

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => sl<InspectionFormBloc>()
                                    ..add(
                                      InspectionFormStarted(
                                        userId: currentUserId,
                                        workOrderId: workOrder.id,
                                      ),
                                    ),
                                  child: InspectionFormPage(
                                    workOrder: workOrder,
                                  ),
                                ),
                              ),
                            );
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

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChipItem({
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
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : const Color(0xFF0B1E36),
      ),
      selectedColor: const Color(0xFF0072CE),
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}
