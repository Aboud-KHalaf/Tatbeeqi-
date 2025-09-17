import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';

class AiActionButton extends StatelessWidget {
  const AiActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final buttonRadius = isSmallScreen ? 10.0 : 12.0;
    final actionIconSize = isSmallScreen ? 20.0 : 22.0;
    return IconButton.filledTonal(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
      ),
      onPressed: () {
        context.push(AppRoutes.labebAiAssistant);
      },
      tooltip: MaterialLocalizations.of(context).searchFieldLabel,
      icon: Icon(
        Icons.auto_awesome,
        size: actionIconSize,
      ),
    );
  }
}
