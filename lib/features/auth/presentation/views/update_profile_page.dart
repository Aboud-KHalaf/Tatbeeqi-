import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

import '../../domain/entities/user.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/update_profile_form.dart';

class UpdateProfilePage extends StatelessWidget {
  final User currentUser;
  const UpdateProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthFormWrapper(
      title: l10n.authUpdateProfileTitle,
      subtitle: l10n.authUpdateProfileSubtitle,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpdateProfileForm(currentUser: currentUser),
        ],
      ),
    );
  }
}
