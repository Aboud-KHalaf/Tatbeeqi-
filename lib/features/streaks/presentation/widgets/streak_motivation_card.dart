import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StreakMotivationCard extends StatefulWidget {
  final int currentStreak;
  final bool hasStreakToday;
  final bool isStreakActive;

  const StreakMotivationCard({
    super.key,
    required this.currentStreak,
    required this.hasStreakToday,
    required this.isStreakActive,
  });

  @override
  State<StreakMotivationCard> createState() => _StreakMotivationCardState();
}

class _StreakMotivationCardState extends State<StreakMotivationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getMotivationMessage() {
    if (widget.hasStreakToday) {
      if (widget.currentStreak >= 7) {
        return "🎉 مذهل! أنت متألق بسلسلة قدرها ${widget.currentStreak} يوماً!";
      } else if (widget.currentStreak >= 3) {
        return "🔥 عمل رائع! واصل الزخم!";
      } else {
        return "✨ ممتاز! أنجزت درس اليوم!";
      }
    } else if (widget.isStreakActive) {
      return "⏰ لا تكسر سلسلتك البالغة ${widget.currentStreak} يوماً! أكمل درساً اليوم.";
    } else if (widget.currentStreak == 0) {
      return "🚀 ابدأ رحلتك التعليمية اليوم! أكمل درسك الأول.";
    } else {
      return "💪 جاهز للعودة؟ أطول سلسلة لك كانت ${widget.currentStreak} يوماً!";
    }
  }

  Color _getCardColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (widget.hasStreakToday) {
      return Colors.green;
    } else if (widget.isStreakActive) {
      return Colors.orange;
    } else {
      return colorScheme.primary;
    }
  }

  IconData _getMotivationIcon() {
    if (widget.hasStreakToday) {
      return Icons.celebration;
    } else if (widget.isStreakActive) {
      return Icons.timer;
    } else {
      return Icons.rocket_launch;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = _getCardColor(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor.withOpacity(0.1),
                    cardColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cardColor.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getMotivationIcon(),
                      color: cardColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _getMotivationMessage(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
