import 'package:flutter/material.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/forget_password_form.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthFormWrapper(
      title: 'استعادة كلمة المرور',
      subtitle: 'أدخل بريدك الإلكتروني لإرسال رابط الاستعادة',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ForgetPasswordForm(),
        ],
      ),
    );
  }
}
