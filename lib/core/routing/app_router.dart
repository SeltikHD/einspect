import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/ui/login_page.dart';
import '../../features/inspections/presentation/bloc/form/inspection_form_bloc.dart';
import '../../features/inspections/presentation/bloc/form/inspection_form_event.dart';
import '../../features/inspections/presentation/bloc/history/inspections_history_bloc.dart';
import '../../features/inspections/presentation/bloc/history/inspections_history_event.dart';
import '../../features/inspections/presentation/ui/inspection_form_page.dart';
import '../../features/inspections/presentation/ui/inspections_history_page.dart';
import '../../features/work_orders/domain/entities/work_order_entity.dart';
import '../../features/work_orders/presentation/bloc/work_orders_bloc.dart';
import '../../features/work_orders/presentation/bloc/work_orders_event.dart';
import '../../features/work_orders/presentation/ui/work_orders_page.dart';
import '../di/service_locator.dart';

abstract final class AppRoutes {
  static const String login = '/login';
  static const String workOrders = '/work-orders';
  static const String inspectionForm = '/inspection-form';
  static const String inspectionsHistory = '/inspections-history';
}

final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case AppRoutes.workOrders:
        final userId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<WorkOrdersBloc>()
                  ..add(WorkOrdersFetchRequested(userId: userId)),
            child: const WorkOrdersPage(),
          ),
          settings: settings,
        );

      case AppRoutes.inspectionForm:
        final args =
            settings.arguments as ({WorkOrderEntity workOrder, String userId});
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<InspectionFormBloc>()
              ..add(
                InspectionFormStarted(
                  workOrderId: args.workOrder.id,
                  userId: args.userId,
                  targetLatitude: args.workOrder.latitude,
                  targetLongitude: args.workOrder.longitude,
                ),
              ),
            child: InspectionFormPage(workOrder: args.workOrder),
          ),
          settings: settings,
        );

      case AppRoutes.inspectionsHistory:
        final userId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<InspectionsHistoryBloc>()
                  ..add(InspectionsHistoryFetchRequested(userId: userId)),
            child: const InspectionsHistoryPage(),
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
