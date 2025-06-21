import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/dropdowns.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _year;
  int? _dept;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SignUpEvent(
            name: _nameController.text.trim(),
            studyYear: _year!,
            department: _dept!,
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
          } else {
            Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),
                StudyYearDropdown(value: _year, onChanged: (v) => setState(() => _year = v)),
                const SizedBox(height: 12),
                DepartmentDropdown(value: _dept, onChanged: (v) => setState(() => _dept = v)),
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
                  label: 'Password',
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 20),
                PrimaryButton(text: 'Create Account', onPressed: _submit),
                const Divider(height: 32),
                GoogleSignInButton(onPressed: () => context.read<AuthBloc>().add(SignInWithGoogleEvent())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
