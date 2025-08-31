import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/forget_password_form.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthFormWrapper(
      title: l10n.authForgetPasswordTitle,
      subtitle: l10n.authForgetPasswordSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ForgetPasswordForm(),
        ],
      ),
    );
  }
}
