import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';

import '../../domain/entities/user.dart';
import '../manager/bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/dropdowns.dart';
import '../widgets/primary_button.dart';

class UpdateProfilePage extends StatefulWidget {
  final User currentUser;
  const UpdateProfilePage({super.key, required this.currentUser});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late int? _year;
  late int? _dept;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()));
          } else {
            Navigator.of(context, rootNavigator: true)
                .popUntil((route) => route.isFirst);
          }
          if (state is AuthError) {
            SnackBarHelper.showError(
              context: context,
              message: state.message,
            );
          } else if (state is AuthAuthenticated) {
            SnackBarHelper.showInfo(
              context: context,
              message: "profile updated",
            );
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AuthTextField(
                  controller: _nameController,
                  label: 'Name',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter name' : null,
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
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter email' : null,
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
                PrimaryButton(text: 'Save Changes', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
