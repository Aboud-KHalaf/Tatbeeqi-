import 'package:flutter/material.dart';

class ModuleProgressSection extends StatefulWidget {
  final double completionPercentage;
  const ModuleProgressSection({super.key, required this.completionPercentage});

  @override
  State<ModuleProgressSection> createState() => _ModuleProgressSectionState();
}

class _ModuleProgressSectionState extends State<ModuleProgressSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final safeEnd = (widget.completionPercentage.isFinite
            ? widget.completionPercentage
            : 0.0)
        .clamp(0.0, 1.0);

    _progress = Tween<double>(begin: 0.0, end: safeEnd).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final safeInput = (widget.completionPercentage.isFinite
            ? widget.completionPercentage
            : 0.0)
        .clamp(0.0, 1.0);
    final isCompleted = safeInput >= 1.0;

    const primaryStart = Color(0xFF6366F1);
    const primaryEnd = Color(0xFF8B5CF6);
    const successStart = Color(0xFF10B981);
    const successEnd = Color(0xFF06D6A0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted
                    ? successStart.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                width: isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isCompleted ? successStart : primaryStart)
                      .withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تقدم المحاضرة',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isCompleted
                                ? 'تم إنجاز جميع دروس المحاضرة بنجاح! 🎉'
                                : 'استمر في التعلم لإكمال المحاضرة',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isCompleted ? successStart : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Percentage Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isCompleted
                              ? [successStart, successEnd]
                              : [primaryStart, primaryEnd],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (isCompleted ? successStart : primaryStart)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCompleted) ...[
                            const Icon(Icons.check_circle,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            '${(((_progress.value.isFinite ? _progress.value : 0.0).clamp(0.0, 1.0)) * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Progress Bar
                AnimatedBuilder(
                  animation: _progress,
                  builder: (context, child) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final safeProgress =
                            (_progress.value.isFinite ? _progress.value : 0.0)
                                .clamp(0.0, 1.0);
                        final progressWidth =
                            constraints.maxWidth * safeProgress;

                        return Stack(
                          children: [
                            // Background
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),

                            // Progress Fill - positioned from right
                            Positioned(
                              right: 0,
                              child: Container(
                                height: 12,
                                width: progressWidth,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isCompleted
                                        ? [successStart, successEnd]
                                        : [primaryStart, primaryEnd],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: safeProgress > 0.1
                                      ? [
                                          BoxShadow(
                                            color: (isCompleted
                                                    ? successStart
                                                    : primaryStart)
                                                .withOpacity(0.4),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),

                            // Progress Dot - positioned from right, moves with animation
                            if (safeProgress > 0.05)
                              Positioned(
                                right: progressWidth - 6,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        isCompleted ? successEnd : primaryEnd,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isCompleted
                                                ? successStart
                                                : primaryStart)
                                            .withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: isCompleted
                                      ? const Icon(Icons.check,
                                          size: 6, color: Colors.white)
                                      : null,
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),

                // Completion Message
                if (isCompleted) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          successStart.withOpacity(0.1),
                          successEnd.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: successStart.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [successStart, successEnd]),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.celebration,
                              size: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'أحسنت! لقد أكملت هذه المحاضرة بامتياز',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: successStart,
                              fontWeight: FontWeight.w600,
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
        );
      },
    );
  }
}
