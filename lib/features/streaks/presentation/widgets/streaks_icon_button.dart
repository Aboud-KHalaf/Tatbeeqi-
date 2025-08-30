import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/streaks/presentation/views/streaks_view.dart';

class StreaksIconButton extends StatelessWidget {
  const StreaksIconButton({
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
        backgroundColor: Colors.orange.shade200,
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
    );
  }
}
