import 'package:einspect/core/errors/failure.dart';
import 'package:einspect/features/auth/domain/repositories/auth_repository.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_event.dart';
import 'package:einspect/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required this._authRepository}) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  /// Verifies whether an existing session exists upon application launch.
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final hasValidToken = await _authRepository.isAuthenticated();

    if (!hasValidToken) {
      // No cached credentials found; redirect technician to login screen
      emit(const Unauthenticated());
      return;
    }

    try {
      // Validate the token and fetch fresh user profile data via GET /auth/me
      // If the token is invalid or expired, this call fails and falls back to Unauthenticated
      final user = await _authRepository.getCurrentUser();
      emit(Authenticated(user: user));
    } catch (_) {
      // Network failure or expired token on cold start forces a clean re-login
      await _authRepository.logout();
      emit(const Unauthenticated());
    }
  }

  /// Handles manual login requests via POST /auth/login.
  Future<void> _onAuthLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Authenticates credentials, persists token in secure storage, and extracts profile
      final session = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      // Successfully authenticated; provides technician entity downstream to stamp created inspections
      emit(Authenticated(user: session.user));
    } catch (error) {
      emit(
        Unauthenticated(
          errorMessage: failureMessage(
            error,
            fallback: 'Não foi possível autenticar. Tente novamente.',
          ),
        ),
      );
    }
  }

  /// Revokes active session and purges sensitive tokens from hardware storage.
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _authRepository.logout();
    emit(const Unauthenticated());
  }
}
