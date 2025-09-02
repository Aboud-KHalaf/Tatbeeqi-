import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_cubit.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

import '../widgets/auth_form_wrapper.dart';
import '../widgets/update_profile_form.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthFormWrapper(
      title: l10n.authUpdateProfileTitle,
      subtitle: l10n.authUpdateProfileSubtitle,
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is UserLoaded)
                UpdateProfileForm(currentUser: state.user),
              if (state is UserError)
                Text(state.message),
            ],
          );
        },
      ),
    );
  }
}
