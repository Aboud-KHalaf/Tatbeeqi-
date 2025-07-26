import 'package:flutter/material.dart';

class ModuleProgressSection extends StatefulWidget {
  final double completionPercentage;
  const ModuleProgressSection({super.key, required this.completionPercentage});

  @override
  State<ModuleProgressSection> createState() => _ModuleProgressSectionState();
}

class _ModuleProgressSectionState extends State<ModuleProgressSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.completionPercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = widget.completionPercentage < 1.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.shade50 : colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? Colors.green.shade300
                    : colorScheme.outline.withValues(alpha: 0.1),
                width: isCompleted ? 2 : 1,
              ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                        color: isCompleted
                            ? Colors.green.shade200.withValues(alpha: 0.6)
                            : colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تقدم الوحدة',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isCompleted
                                ? 'تم إنجاز جميع دروس المحاضرة بنجاح!'
                                : 'استمر في التعلم لإكمال المحاضرة',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isCompleted
                                  ? Colors.green.shade500
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.shade500
                            : colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isCompleted
                            ? [
                                BoxShadow(
                                  color: isCompleted
                                      ? Colors.green.shade200
                                          .withValues(alpha: 0.6)
                                      : colorScheme.primary
                                          .withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCompleted)
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: colorScheme.onPrimary,
                            ),
                          if (isCompleted) const SizedBox(width: 4),
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return Text(
                                '${(_progressAnimation.value * 100).toInt()}%',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isCompleted
                                      ? colorScheme.onPrimary
                                      : colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width *
                              (_progressAnimation.value *
                                  0.85), // Account for padding
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCompleted
                                  ? [
                                      Colors.green.shade500,
                                      Colors.green.shade400,
                                    ]
                                  : [
                                      colorScheme.primary
                                          .withValues(alpha: 0.8),
                                      colorScheme.primary,
                                    ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: _progressAnimation.value > 0.1
                                ? [
                                    BoxShadow(
                                      color: isCompleted
                                          ? Colors.green.shade200
                                              .withValues(alpha: 0.6)
                                          : colorScheme.primary
                                              .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      },
                    ),
                    if (isCompleted)
                      Positioned(
                        right: 8,
                        top: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check,
                            size: 10,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                if (isCompleted) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.celebration,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'أحسنت! لقد أكملت هذه الوحدة',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
