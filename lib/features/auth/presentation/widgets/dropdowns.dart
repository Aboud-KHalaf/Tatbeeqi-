import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudyYearDropdown extends StatefulWidget {
  final int? value;
  final void Function(int?)? onChanged;
  final bool enabled;

  const StudyYearDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<StudyYearDropdown> createState() => _StudyYearDropdownState();
}

class _StudyYearDropdownState extends State<StudyYearDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  static const Map<int, String> _studyYears = {
    1: 'First Year',
    2: 'Second Year',
    3: 'Third Year',
    4: 'Fourth Year',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
    if (hasFocus) {
      _animationController.forward();
      HapticFeedback.selectionClick();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Focus(
            onFocusChange: _onFocusChange,
            child: DropdownButtonFormField<int>(
              value: widget.value,
              onChanged: widget.enabled
                  ? (value) {
                      widget.onChanged?.call(value);
                      HapticFeedback.lightImpact();
                    }
                  : null,
              items: _studyYears.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              entry.value,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Study Year',
                hintText: 'Select your study year',
                prefixIcon: Icon(
                  Icons.school_outlined,
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: _isFocused
                    ? colorScheme.primaryContainer.withOpacity(0.1)
                    : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 2,
                  ),
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
                errorStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (val) =>
                  val == null ? 'Please select your study year' : null,
              dropdownColor: colorScheme.surface,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: widget.enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DepartmentDropdown extends StatefulWidget {
  final int? value;
  final void Function(int?)? onChanged;
  final bool enabled;

  const DepartmentDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<DepartmentDropdown> createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  static const Map<int, String> _departments = {
    1: 'Computer Science',
    2: 'Information Technology',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
    if (hasFocus) {
      _animationController.forward();
      HapticFeedback.selectionClick();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Focus(
            onFocusChange: _onFocusChange,
            child: DropdownButtonFormField<int>(
              value: widget.value,
              onChanged: widget.enabled
                  ? (value) {
                      widget.onChanged?.call(value);
                      HapticFeedback.lightImpact();
                    }
                  : null,
              items: _departments.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                entry.value,
                                style: theme.textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Department',
                hintText: 'Select your department',
                prefixIcon: Icon(
                  Icons.business_outlined,
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: _isFocused
                    ? colorScheme.primaryContainer.withOpacity(0.1)
                    : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 2,
                  ),
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
                errorStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (val) =>
                  val == null ? 'Please select your department' : null,
              dropdownColor: colorScheme.surface,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: widget.enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ),
        );
      },
    );
  }
}
