import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/user_details_section.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/shortcuts_section.dart';
import 'package:tatbeeqi/features/more/presentation/widgets/settings_section.dart';

class MoreView extends StatefulWidget {
  static const String routePath = '/MoreView';

  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetailsSection(),
          SizedBox(height: 24),
          ShortcutsSection(),
          SizedBox(height: 24),
          SettingsSection(),
        ],
      ),
    );
  }
}
