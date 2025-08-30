import 'package:flutter/material.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/sign_in_form.dart';
import '../widgets/sign_in_footer.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthFormWrapper(
      title: 'تسجيل الدخول',
      subtitle: 'سجل دخولك لمتابعة رحلتك التعليمية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignInForm(),
          SizedBox(height: 32),
          SignInFooter(),
        ],
      ),
    );
  }
}
