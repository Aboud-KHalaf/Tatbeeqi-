import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StreakCalendar extends StatefulWidget {
  final DateTime? lastCompletedDate;
  final int currentStreak;

  const StreakCalendar({
    super.key,
    this.lastCompletedDate,
    required this.currentStreak,
  });

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

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

  List<DateTime> _getLast7Days() {
    final today = DateTime.now();
    return List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
  }

  bool _isDateCompleted(DateTime date) {
    if (widget.lastCompletedDate == null) return false;
    
    final today = DateTime.now();
    final daysDifference = today.difference(date).inDays;
    
    // If current streak is greater than days difference, this day was completed
    return widget.currentStreak > daysDifference;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
           date.month == today.month &&
           date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final days = _getLast7Days();

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'النشاط الأخير',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: days.asMap().entries.map((entry) {
                    final index = entry.key;
                    final date = entry.value;
                    final isCompleted = _isDateCompleted(date);
                    final isToday = _isToday(date);

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 200 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: _DayIndicator(
                            date: date,
                            isCompleted: isCompleted,
                            isToday: isToday,
                            onTap: () {
                              HapticFeedback.selectionClick();
                            },
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _buildLegend(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: colorScheme.primary,
          label: 'مكتمل',
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: colorScheme.outline.withOpacity(0.3),
          label: 'غير مكتمل',
        ),
      ],
    );
  }
}

class _DayIndicator extends StatefulWidget {
  final DateTime date;
  final bool isCompleted;
  final bool isToday;
  final VoidCallback onTap;

  const _DayIndicator({
    required this.date,
    required this.isCompleted,
    required this.isToday,
    required this.onTap,
  });

  @override
  State<_DayIndicator> createState() => _DayIndicatorState();
}

class _DayIndicatorState extends State<_DayIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isToday && widget.isCompleted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isToday && widget.isCompleted
                ? _pulseAnimation.value
                : 1.0,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isCompleted
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: widget.isToday
                        ? Border.all(
                            color: colorScheme.primary,
                            width: 2,
                          )
                        : null,
                    boxShadow: widget.isCompleted
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: widget.isCompleted
                      ? Icon(
                          Icons.check,
                          color: colorScheme.onPrimary,
                          size: 20,
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  _getDayName(widget.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: widget.isToday
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: widget.isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDayName(DateTime date) {
    final days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return days[date.weekday % 7];
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
