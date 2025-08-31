import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/sign_up_form.dart';
import '../widgets/sign_up_footer.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthFormWrapper(
      title: l10n.authSignUpTitle,
      subtitle: l10n.authSignUpSubtitle,
      child: const Column(
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
