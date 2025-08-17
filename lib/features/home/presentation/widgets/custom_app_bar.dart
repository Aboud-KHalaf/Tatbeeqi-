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
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StreaksView(),
              ));
            },
            icon: const Icon(
              Icons.fireplace_rounded,
              color: Colors.red,
            )),
        const AiActionButton(),
        SizedBox(width: isSmallScreen ? 6 : 10),
        // Notifications Button
        Material(
          borderRadius: BorderRadius.circular(isSmallScreen ? 10.0 : 12.0),
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          child: InkWell(
            onTap: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
            borderRadius: BorderRadius.circular(isSmallScreen ? 10.0 : 12.0),
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
              child: Icon(
                Icons.notifications_none_rounded,
                color: colorScheme.onSurfaceVariant,
                size: isSmallScreen ? 18 : 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight + 10);
  }
}
