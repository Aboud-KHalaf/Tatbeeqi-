import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/update_profile_form.dart';

class UpdateProfilePage extends StatelessWidget {
  final User currentUser;
  const UpdateProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return AuthFormWrapper(
      title: 'تحديث الملف الشخصي',
      subtitle: 'قم بتحديث معلومات حسابك',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpdateProfileForm(currentUser: currentUser),
        ],
      ),
    );
  }
}
