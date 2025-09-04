import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/notifications_view.dart';

class NotificationsIconButton extends StatelessWidget {
  const NotificationsIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final buttonRadius = isSmallScreen ? 10.0 : 12.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton.outlined(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NotificationsView()));
          },
          icon: Icon(
            Icons.notifications_none_rounded,
            size: isSmallScreen ? 20 : 22,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: 'Notifications',
        ),
        PositionedDirectional(
          end: 6,
          top: 6,
          child: Container(
            width: isSmallScreen ? 7 : 8,
            height: isSmallScreen ? 7 : 8,
            decoration: BoxDecoration(
              color: colorScheme.error,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.error.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
