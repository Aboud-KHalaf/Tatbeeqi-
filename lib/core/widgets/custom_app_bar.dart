import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/constants/constants.dart';
import 'package:tatbeeqi/core/widgets/ai_action_button.dart';
import 'package:tatbeeqi/features/notifications/presentation/widgets/notifications_icon_button.dart';
import 'package:tatbeeqi/features/streaks/presentation/widgets/streaks_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return AppBar(
      surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      actionsPadding: AppDimensConstants.appBarHorizontalPadding,
      centerTitle: false,
      actions: const [
        StreaksIconButton(),
        AiActionButton(),
        NotificationsIconButton(),
      ],
      title: Text(
        title,
        style: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: colorScheme.primary,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
