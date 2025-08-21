import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/ai_assistant/ai_assistant_usage_example.dart';

class AiActionButton extends StatelessWidget {
  const AiActionButton({
    super.key,
    this.radius,
    this.iconSize,
    this.tooltip,
  });

  final double? radius;
  final double? iconSize;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final resolvedRadius = radius ?? (isSmallScreen ? 10.0 : 12.0);
    final resolvedIconSize = iconSize ?? (isSmallScreen ? 20.0 : 22.0);

    return IconButton.filledTonal(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(resolvedRadius),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AiAssistantUsageExample(),
          ),
        );
      },
      tooltip: tooltip ?? MaterialLocalizations.of(context).searchFieldLabel,
      icon: Icon(
        Icons.auto_awesome,
        size: resolvedIconSize,
      ),
    );
  }
}
