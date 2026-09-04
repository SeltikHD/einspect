import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/ui/login_page.dart';
import 'features/inspections/domain/repositories/inspections_repository.dart';
import 'features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'features/work_orders/presentation/bloc/work_orders_event.dart';
import 'features/work_orders/presentation/ui/work_orders_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const EInspectApp());
}

class EInspectApp extends StatelessWidget {
  const EInspectApp({super.key});

  static const Color _brandPrimary = Color(0xFF0072CE);
  static const Color _brandNavy = Color(0xFF0B1E36);
  static const Color _surfaceLight = Color(0xFFF4F7FA);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      // Trigger token verification in secure storage immediately on startup
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp(
        title: 'eInspect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: _surfaceLight,
          colorScheme: ColorScheme.fromSeed(
            seedColor: _brandPrimary,
            primary: _brandPrimary,
            secondary: _brandNavy,
            surface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: _brandNavy,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandPrimary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: _brandPrimary, width: 2),
            ),
          ),
        ),
        home: const AuthSessionGatekeeper(),
      ),
    );
  }
}

/// Root widget acting as a protective barrier based on authentication state.
/// Ensures unauthenticated requests cannot access internal pages.
class AuthSessionGatekeeper extends StatelessWidget {
  const AuthSessionGatekeeper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Triggers automatic synchronization pipeline when technician logs in
        if (state is Authenticated) {
          sl<InspectionsRepository>().startAutoSync(state.user.id);
        } else if (state is Unauthenticated) {
          sl<InspectionsRepository>().stopAutoSync();
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return BlocProvider<WorkOrdersBloc>(
            create: (_) =>
                sl<WorkOrdersBloc>()
                  ..add(WorkOrdersFetchRequested(userId: state.user.id)),
            child: const WorkOrdersPage(),
          );
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
