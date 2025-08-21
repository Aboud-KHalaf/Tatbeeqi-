import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/ai_action_button.dart';
import 'package:tatbeeqi/features/streaks/presentation/views/streaks_view.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

import '../../../auth/presentation/manager/bloc/auth_bloc.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Get screen width to adjust layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final buttonRadius = isSmallScreen ? 10.0 : 12.0;
    final actionIconSize = isSmallScreen ? 20.0 : 22.0;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: isSmallScreen ? 8.0 : 16.0,
      centerTitle: false,
      title: Text(
        l10n.home,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          fontSize: isSmallScreen ? 18 : null,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      actions: [
        // Streaks action (tonal)
        IconButton.filledTonal(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const StreaksView(),
            ));
          },
          icon: Icon(
            Icons.local_fire_department_rounded,
            size: actionIconSize,
          ),
          tooltip: l10n.home,
        ),
        AiActionButton(
          radius: buttonRadius,
          iconSize: actionIconSize,
          tooltip: 'AI Assistant',
        ),
        SizedBox(width: isSmallScreen ? 6 : 10),
        // Notifications button with small badge dot (keeps existing onTap behavior)
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton.outlined(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
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
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight + 10);
  }
}
