import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/features/auth/presentation/widgets/primary_button.dart';

import '../../domain/entities/user.dart' as ent;
import '../manager/bloc/auth_bloc.dart';
import 'auth_text_field.dart';
import 'dropdowns.dart';

class UpdateProfileForm extends StatefulWidget {
  final ent.User currentUser;
  const UpdateProfileForm({super.key, required this.currentUser});

  @override
  State<UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  int? _year;
  int? _dept;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _emailController = TextEditingController(text: widget.currentUser.email);
    _passwordController = TextEditingController();
    _year = widget.currentUser.studyYear;
    _dept = widget.currentUser.department;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      context.read<AuthBloc>().add(UpdateUserEvent(
            name: _nameController.text.trim(),
            studyYear: _year,
            department: _dept,
            email: _emailController.text.trim(),
            password: _passwordController.text.isEmpty
                ? null
                : _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading &&
              state.operation == AuthOperation.updateProfile;
        });
        if (state is AuthError) {
          SnackBarHelper.showError(context: context, message: state.message);
        } else if (state is AuthAuthenticated) {
          SnackBarHelper.showInfo(context: context, message: l10n.profileUpdatedSuccessfully);
          Navigator.of(context).pop();
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
              validator: (v) => (v == null || v.isEmpty) ? l10n.authEnterName : null,
            ),
            const SizedBox(height: 12),
            StudyYearDropdown(
                value: _year, onChanged: (v) => setState(() => _year = v)),
            const SizedBox(height: 12),
            DepartmentDropdown(
                value: _dept, onChanged: (v) => setState(() => _dept = v)),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _emailController,
              label: l10n.authEmailLabel,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || v.isEmpty) ? l10n.authEnterEmail : null,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _passwordController,
              label: l10n.profileNewPasswordOptional,
              obscureText: true,
              validator: (v) => (v != null && v.isNotEmpty && v.length < 6)
                  ? l10n.profileMin6Chars
                  : null,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
                text: l10n.profileSaveChanges,
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}
