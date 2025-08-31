import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';

import '../manager/bloc/auth_bloc.dart';
import 'auth_text_field.dart';
import 'dropdowns.dart';
import 'primary_button.dart';
import 'google_sign_in_button.dart';
 
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
              label: 'الاسم الكامل',
              hint: 'أدخل اسمك الكامل',
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال الاسم';
                if (v.length < 2) return 'الاسم يجب أن يكون حرفين على الأقل';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الإلكتروني',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'يرجى إدخال البريد الإلكتروني';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) return 'يرجى إدخال بريد إلكتروني صحيح';
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
              label: 'كلمة المرور',
              hint: 'أدخل كلمة المرور',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'يرجى إدخال كلمة المرور';
                if (value.length < 6)
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmPasswordController,
              label: 'تأكيد كلمة المرور',
              hint: 'أعد إدخال كلمة المرور',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'يرجى تأكيد كلمة المرور';
                if (value != _passwordController.text)
                  return 'كلمة المرور غير متطابقة';
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
                    text: 'إنشاء الحساب',
                    onPressed: _isLoading ? null : _submit,
                    icon: const Icon(Icons.person_add_rounded),
                    isLoading: _isLoading,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const _AuthDividerLocalized(text: 'أو'),
            const SizedBox(height: 24),
            GoogleSignInButton(
              onPressed: _handleGoogleSignIn,
              isLoading: _isGoogleLoading,
              text: 'المتابعة مع جوجل',
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthDividerLocalized extends StatelessWidget {
  final String text;
  const _AuthDividerLocalized({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outline.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
        ),
        Expanded(child: Divider(color: colorScheme.outline.withOpacity(0.3))),
      ],
    );
  }
}
