import 'package:flutter/material.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/sign_up_form.dart';
import '../widgets/sign_up_footer.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthFormWrapper(
      title: 'إنشاء حساب جديد',
      subtitle: 'أنشئ حسابك الجديد وابدأ رحلتك التعليمية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignUpForm(),
          SizedBox(height: 32),
          SignUpFooter(),
        ],
      ),
    );
  }
}
