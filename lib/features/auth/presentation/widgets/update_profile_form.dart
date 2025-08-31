import 'package:flutter/material.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading &&
              state.operation == AuthOperation.updateProfile;
        });
        if (state is AuthError) {
          SnackBarHelper.showError(context: context, message: state.message);
        } else if (state is AuthAuthenticated) {
          SnackBarHelper.showInfo(context: context, message: 'Profile updated');
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
              label: 'Name',
              validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
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
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _passwordController,
              label: 'New Password (optional)',
              obscureText: true,
              validator: (v) => (v != null && v.isNotEmpty && v.length < 6)
                  ? 'Min 6 chars'
                  : null,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
                text: 'Save Changes',
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}
