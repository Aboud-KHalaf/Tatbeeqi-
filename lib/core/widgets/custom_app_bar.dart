import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/constants/constants.dart';
import 'package:tatbeeqi/core/widgets/ai_action_button.dart';
import 'package:tatbeeqi/features/notifications/presentation/widgets/notifications_icon_button.dart';
import 'package:tatbeeqi/features/streaks/presentation/widgets/streaks_icon_button.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/core/network/network_info.dart';

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
      actions: [
        const StreaksIconButton(),
        const AiActionButton(),
        const NotificationsIconButton(),
        // Offline indicator (shows only when there is NO internet)
        StreamBuilder<bool>(
          stream: sl<NetworkInfo>().connectivityStream,
          builder: (context, snapshot) {
            final isConnected = snapshot.data ?? true; // default to connected
            if (isConnected) return const SizedBox.shrink();
            final cs = Theme.of(context).colorScheme;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 4.0),
              child: IconButton.filledTonal(
                onPressed: () {},
                tooltip: 'لا يوجد اتصال بالانترنت',
                style: IconButton.styleFrom(
                  backgroundColor: cs.error,
                ),
                icon: Icon(
                  Icons.wifi_off_rounded,
                  color: cs.errorContainer,
                ),
              ),
            );
          },
        ),
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
