import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:tatbeeqi/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

import '../manager/bloc/auth_bloc.dart';
import 'primary_button.dart';
import 'auth_text_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  late final AnimationController _buttonAnimationController;
  late final Animation<double> _scaleAnimation;

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  // Visibility handled internally by AuthTextField when obscureText=true

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(
            parent: _buttonAnimationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      _buttonAnimationController.forward().then((_) {
        _buttonAnimationController.reverse();
      });
      context.read<AuthBloc>().add(SignInEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  void _handleGoogleSignIn() {
    HapticFeedback.lightImpact();
    context.read<AuthBloc>().add(SignInWithGoogleEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading =
              state is AuthLoading && state.operation == AuthOperation.signIn;
          _isGoogleLoading = state is AuthLoading &&
              state.operation == AuthOperation.signInWithGoogle;
        });
        if (state is AuthError) {
          SnackBarHelper.showError(context: context, message: state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _emailController,
              label: l10n.authEmailLabel,
              hint: l10n.authEnterEmail,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authEnterEmail;
                }
                if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
                    .hasMatch(value)) {
                  return l10n.authInvalidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: l10n.authPasswordLabel,
              hint: l10n.authEnterPassword,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return l10n.authEnterPassword;
                if (value.length < 6) return l10n.authPasswordTooShort;
                return null;
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgetPassword),
                child: Text(
                  l10n.authForgotPasswordLink,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: PrimaryButton(
                    text: l10n.authSignInButton,
                    onPressed: _isLoading ? null : _handleSignIn,
                    icon: const Icon(Icons.login_rounded),
                    isLoading: _isLoading,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const AuthDivider(),
            const SizedBox(height: 24),
            GoogleSignInButton(
              onPressed: _handleGoogleSignIn,
              isLoading: _isGoogleLoading,
            ),
          ],
        ),
      ),
    );
  }
}
