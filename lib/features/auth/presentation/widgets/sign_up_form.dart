import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

import '../manager/bloc/auth_bloc.dart';
import 'auth_form_wrapper.dart';
import 'auth_text_field.dart';
import 'dropdowns.dart';
import 'google_sign_in_button.dart';
import 'primary_button.dart';
 
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus is handled by default form behavior and AuthTextField animations

  int? _year;
  int? _dept;
  bool _isLoading = false;
  final bool _isGoogleLoading = false;
  // Visibility handled internally by AuthTextField when obscureText=true

  late final AnimationController _buttonAnimationController;
  late final Animation<double> _scaleAnimation;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // no focus nodes to dispose
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      _buttonAnimationController
          .forward()
          .then((_) => _buttonAnimationController.reverse());
      context.read<AuthBloc>().add(SignUpEvent(
            name: _nameController.text.trim(),
            studyYear: _year!,
            department: _dept!,
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
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading =
              state is AuthLoading && state.operation == AuthOperation.signUp;
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
              controller: _nameController,
              label: l10n.authFullNameLabel,
              hint: l10n.authFullNameHint,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.authFullNameEmpty;
                if (v.length < 2) return l10n.authFullNameTooShort;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: l10n.authEmailLabel,
              hint: l10n.authEmailHint,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.authEmailEmpty;
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value))
                  return l10n.authInvalidEmail;
                return null;
              },
            ),
            const SizedBox(height: 16),
            StudyYearDropdown(
                value: _year, onChanged: (v) => setState(() => _year = v)),
            const SizedBox(height: 16),
            DepartmentDropdown(
                value: _dept, onChanged: (v) => setState(() => _dept = v)),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: l10n.authPasswordLabel,
              hint: l10n.authPasswordHint,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.authPasswordEmpty;
                if (value.length < 6) return l10n.authPasswordTooShort;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmPasswordController,
              label: l10n.authConfirmPasswordLabel,
              hint: l10n.authConfirmPasswordHint,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return l10n.authConfirmPasswordEmpty;
                if (value != _passwordController.text) return l10n.authPasswordMismatch;
                return null;
              },
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: PrimaryButton(
                    text: l10n.authCreateAccountButton,
                    onPressed: _isLoading ? null : _submit,
                    icon: const Icon(Icons.person_add_rounded),
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
