import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/sign_in_form.dart';
import '../widgets/sign_in_footer.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthFormWrapper(
      title: l10n.authSignInTitle,
      subtitle: l10n.authSignInSubtitle,
      child: const Column(
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
