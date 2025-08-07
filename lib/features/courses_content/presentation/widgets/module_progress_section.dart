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
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.completionPercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutExpo),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
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

  // Modern color palette
  Color get _primaryGradientStart => const Color(0xFF6366F1); // Indigo-500
  Color get _primaryGradientEnd => const Color(0xFF8B5CF6); // Violet-500
  Color get _successGradientStart => const Color(0xFF10B981); // Emerald-500
  Color get _successGradientEnd => const Color(0xFF06D6A0); // Turquoise
  Color get _surfaceLight => const Color(0xFFFFFFFF);
  Color get _cardBorder => const Color(0xFFE2E8F0);
  Color get _textPrimary => const Color(0xFF1E293B);
  Color get _textSecondary => const Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = widget.completionPercentage >= 1.0;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : _surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted
                    ? _successGradientStart.withValues(alpha: 0.3)
                    : _cardBorder.withValues(alpha: isDark ? 0.2 : 1.0),
                width: isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isCompleted
                      ? _successGradientStart.withValues(alpha: 0.15)
                      : _primaryGradientStart.withValues(alpha: 0.08),
                  blurRadius: isCompleted ? 20 : 15,
                  offset: const Offset(0, 8),
                  spreadRadius: isCompleted ? 2 : 0,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFFE2E8F0).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isCompleted
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _successGradientStart.withValues(alpha: 0.05),
                          _successGradientEnd.withValues(alpha: 0.03),
                        ],
                      )
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : _textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isCompleted
                                  ? 'تم إنجاز جميع دروس المحاضرة بنجاح! 🎉'
                                  : 'استمر في التعلم لإكمال المحاضرة',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isCompleted
                                    ? _successGradientStart
                                    : (isDark
                                        ? Colors.grey.shade300
                                        : _textSecondary),
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: isCompleted
                              ? LinearGradient(
                                  colors: [
                                    _successGradientStart,
                                    _successGradientEnd
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    _primaryGradientStart,
                                    _primaryGradientEnd
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isCompleted
                                  ? _successGradientStart.withValues(alpha: 0.4)
                                  : _primaryGradientStart.withValues(
                                      alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isCompleted) ...[
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                            ],
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return Text(
                                  '${(_progressAnimation.value * 100).toInt()}%',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Container(
                            height: 14,
                            width: MediaQuery.of(context).size.width *
                                (_progressAnimation.value * 0.82),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isCompleted
                                    ? [
                                        _successGradientStart,
                                        _successGradientEnd
                                      ]
                                    : [
                                        _primaryGradientStart,
                                        _primaryGradientEnd
                                      ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _progressAnimation.value > 0.1
                                  ? [
                                      BoxShadow(
                                        color: isCompleted
                                            ? _successGradientStart.withValues(
                                                alpha: 0.4)
                                            : _primaryGradientStart.withValues(
                                                alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  // Shimmer effect
                                  if (_progressAnimation.value > 0.1)
                                    AnimatedBuilder(
                                      animation: _shimmerAnimation,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            _shimmerAnimation.value * 200,
                                            0,
                                          ),
                                          child: Container(
                                            width: 50,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white
                                                      .withValues(alpha: 0.0),
                                                  Colors.white
                                                      .withValues(alpha: 0.4),
                                                  Colors.white
                                                      .withValues(alpha: 0.0),
                                                ],
                                                stops: const [0.0, 0.5, 1.0],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Progress indicator dot
                      if (widget.completionPercentage > 0.1)
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Positioned(
                              left: (MediaQuery.of(context).size.width *
                                      0.82 *
                                      _progressAnimation.value) -
                                  8,
                              top: -1,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? _successGradientEnd
                                      : _primaryGradientEnd,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isCompleted
                                          ? _successGradientStart.withValues(
                                              alpha: 0.5)
                                          : _primaryGradientStart.withValues(
                                              alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        size: 8,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                    ],
                  ),

                  if (isCompleted) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _successGradientStart.withValues(alpha: 0.1),
                            _successGradientEnd.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _successGradientStart.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _successGradientStart,
                                  _successGradientEnd
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.celebration_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'أحسنت! لقد أكملت هذه الوحدة بامتياز',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _successGradientStart,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
