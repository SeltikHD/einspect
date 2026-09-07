import 'package:einspect/core/di/service_locator.dart';
import 'package:einspect/core/network/network_status_cubit.dart';
import 'package:einspect/core/routing/app_router.dart';
import 'package:einspect/core/theme/app_theme.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_event.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_state.dart';
import 'package:einspect/features/auth/presentation/ui/login_page.dart';
import 'package:einspect/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:einspect/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:einspect/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:einspect/features/work_orders/presentation/ui/work_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await setupServiceLocator();
  runApp(EInspectApp(dependencies: dependencies));
}

class EInspectApp extends StatelessWidget {
  final AppDependencies dependencies;

  const EInspectApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => dependencies.authBloc..add(const AuthCheckRequested()),
        ),
        BlocProvider<WorkOrdersBloc>(
          create: (_) => dependencies.workOrdersBloc,
        ),
        BlocProvider(
          create: (_) =>
              NetworkStatusCubit(networkInfo: dependencies.networkInfo),
        ),
      ],
      child: MaterialApp(
        title: 'eInspect',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: AuthSessionGatekeeper(
          inspectionsRepository: dependencies.inspectionsRepository,
        ),
      ),
    );
  }
}

/// Root widget acting as a protective barrier based on authentication state.
/// Ensures unauthenticated requests cannot access internal pages.
class AuthSessionGatekeeper extends StatelessWidget {
  final InspectionsRepository _inspectionsRepository;

  const AuthSessionGatekeeper({
    super.key,
    required this._inspectionsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Triggers automatic synchronization pipeline when technician logs in
        if (state is Authenticated) {
          _inspectionsRepository.startAutoSync(state.user.id);
          context.read<WorkOrdersBloc>().add(
            WorkOrdersFetchRequested(userId: state.user.id),
          );
        } else if (state is Unauthenticated) {
          _inspectionsRepository.stopAutoSync();
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return const WorkOrdersPage();
        }

        if (state is Unauthenticated || state is AuthLoading) {
          return const LoginPage();
        }

        // Loading state while checking persistent session or logging in
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
