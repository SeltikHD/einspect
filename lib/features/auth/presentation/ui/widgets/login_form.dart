import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orbytis_challenge/core/utils/form_validators.dart';
import 'package:orbytis_challenge/core/widgets/primary_button.dart';
import 'package:orbytis_challenge/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:orbytis_challenge/features/auth/presentation/bloc/auth_event.dart';
import 'package:orbytis_challenge/features/auth/presentation/bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(
        AuthLoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              hintText: 'exemplo@orbytis.com.br',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: FormValidators.email,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _isPasswordObscured,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _isPasswordObscured = !_isPasswordObscured),
              ),
            ),
            validator: (value) =>
                FormValidators.requiredField(value, message: 'Informe a senha'),
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return PrimaryButton(
                label: 'Entrar',
                isLoading: state is AuthLoading,
                onPressed: _submit,
              );
            },
          ),
        ],
      ),
    );
  }
}
