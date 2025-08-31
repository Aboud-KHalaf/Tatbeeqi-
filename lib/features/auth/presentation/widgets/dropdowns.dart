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
  bool _isMenuOpen = false;

  Map<int, String> _studyYears = {};

  static const Map<int, String> _studyYearsAr = {
    1: 'السنة الأولى',
    2: 'السنة الثانية',
    3: 'السنة الثالثة',
    4: 'السنة الرابعة',
  };
  static const Map<int, String> _studyYearsEn = {
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
    final locale = Localizations.localeOf(context);  
    switch (locale.languageCode) {
      case 'ar':
        _studyYears = _studyYearsAr;
        break;
      case 'en':
        _studyYears = _studyYearsEn;
        break;
    }
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
                      _isMenuOpen = false;
                    }
                  : null,
              onTap: () {
                if (widget.enabled) {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                  });
                }
              },
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              menuMaxHeight: 320,
              alignment: AlignmentDirectional.centerStart,
              icon: AnimatedRotation(
                turns: (_isFocused || _isMenuOpen) ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Icon(
                  Icons.expand_more_rounded,
                  color: (_isFocused || _isMenuOpen)
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              items: _studyYears.entries
                  .map((entry) => DropdownMenuItem<int>(
                        value: entry.key,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: theme.textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.value == entry.key)
                                Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (ctx) => _studyYears.entries
                  .map((entry) => Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          entry.value,
                          style: theme.textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'السنة الدراسية',
                hintText: 'اختر السنة الدراسية',
                alignLabelWithHint: true,
                prefixIcon: Icon(
                  Icons.school_outlined,
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: _isFocused
                    ? colorScheme.primaryContainer.withOpacity(0.10)
                    : colorScheme.surfaceContainerHighest.withOpacity(0.30),
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
                  color: colorScheme.onSurfaceVariant.withOpacity(0.60),
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
                  val == null ? 'يرجى اختيار السنة الدراسية' : null,
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
  bool _isMenuOpen = false;

  static const Map<int, String> _departmentsAr = {
    1: 'تقنيات الحاسب',
    2: 'التكييف والتبريد',
  };
  static const Map<int, String> _departmentsEn = {
    1: 'Computer Engineering',
    2: 'Air Conditioning and Refrigeration',
  };
  Map<int, String> _departments = {};
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
    final locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'ar':
         _departments = _departmentsAr;
        break;
      case 'en':
         _departments = _departmentsEn;
        break;
    }
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
                      _isMenuOpen = false;
                    }
                  : null,
              onTap: () {
                if (widget.enabled) {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                  });
                }
              },
              isExpanded: true,
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              menuMaxHeight: 320,
              alignment: AlignmentDirectional.centerStart,
              icon: AnimatedRotation(
                turns: (_isFocused || _isMenuOpen) ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Icon(
                  Icons.expand_more_rounded,
                  color: (_isFocused || _isMenuOpen)
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              items: _departments.entries
                  .map((entry) => DropdownMenuItem<int>(
                        value: entry.key,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: theme.textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.value == entry.key)
                                Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (ctx) => _departments.entries
                  .map((entry) => Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          entry.value,
                          style: theme.textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'القسم',
                hintText: 'اختر القسم',
                prefixIcon: Icon(
                  Icons.business_outlined,
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: _isFocused
                    ? colorScheme.primaryContainer.withOpacity(0.10)
                    : colorScheme.surfaceContainerHighest.withOpacity(0.30),
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
                  color: colorScheme.onSurfaceVariant.withOpacity(0.60),
                ),
                errorStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (val) => val == null ? 'يرجى اختيار القسم' : null,
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
