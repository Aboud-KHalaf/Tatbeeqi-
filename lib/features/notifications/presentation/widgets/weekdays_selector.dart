import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeekdaysSelector extends StatefulWidget {
  final List<int> selectedDays;
  final Function(List<int>) onDaysChanged;

  const WeekdaysSelector({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  @override
  State<WeekdaysSelector> createState() => _WeekdaysSelectorState();
}

class _WeekdaysSelectorState extends State<WeekdaysSelector> {
  late List<int> _selectedDays;

  final List<String> _weekdayNames = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.selectedDays);
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      _selectedDays.sort();
    });
    
    HapticFeedback.selectionClick();
    widget.onDaysChanged(_selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأيام',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            final day = index + 1; // 1-7 for Monday to Sunday
            final isSelected = _selectedDays.contains(day);
            
            return GestureDetector(
              onTap: () => _toggleDay(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _weekdayNames[index],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
        if (_selectedDays.isEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'يرجى اختيار يوم واحد على الأقل',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
