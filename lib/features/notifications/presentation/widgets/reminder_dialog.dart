import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit/reminders_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit/reminders_state.dart';
import 'package:tatbeeqi/features/notifications/presentation/widgets/reminder_time_picker.dart';
import 'package:tatbeeqi/features/notifications/presentation/widgets/weekdays_selector.dart';
import 'package:uuid/uuid.dart';

class ReminderDialog extends StatefulWidget {
  final String? courseId;
  final String courseName;

  const ReminderDialog({
    super.key,
    this.courseId,
    required this.courseName,
  });

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  List<int> _selectedDays = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Set default values
    _titleController.text = 'تذكير دراسة ${widget.courseName}';
    _bodyController.text = 'حان وقت دراسة ${widget.courseName}!';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _scheduleReminder(BuildContext context) {
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار يوم واحد على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال عنوان التذكير'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reminder = Reminder(
      id: const Uuid().v4(),
      days: _selectedDays,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      courseId: widget.courseId,
      createdAt: DateTime.now(),
    );

    context.read<RemindersCubit>().scheduleReminder(reminder);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => sl<RemindersCubit>(),
      child: BlocListener<RemindersCubit, RemindersState>(
        listener: (context, state) {
          if (state is ReminderScheduled) {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم جدولة التذكير بنجاح'),
                backgroundColor: colorScheme.primary,
              ),
            );
          } else if (state is RemindersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${state.message}'),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 600),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(theme, colorScheme),
                          const SizedBox(height: 24),
                          _buildTitleField(theme),
                          const SizedBox(height: 16),
                          _buildBodyField(theme),
                          const SizedBox(height: 24),
                          WeekdaysSelector(
                            selectedDays: _selectedDays,
                            onDaysChanged: (days) {
                              setState(() {
                                _selectedDays = days;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          ReminderTimePicker(
                            initialTime: _selectedTime,
                            onTimeChanged: (time) {
                              setState(() {
                                _selectedTime = time;
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          _buildButtons(theme, colorScheme),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.schedule,
            color: colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إضافة تذكير',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'جدولة تذكير لدراسة ${widget.courseName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'عنوان التذكير',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'مثال: تذكير دراسة الرياضيات',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نص التذكير',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bodyController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'مثال: حان وقت دراسة الرياضيات!',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(ThemeData theme, ColorScheme colorScheme) {
    return BlocBuilder<RemindersCubit, RemindersState>(
      builder: (context, state) {
        final isLoading = state is ReminderScheduling;

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('إلغاء'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _scheduleReminder(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Text('جدولة التذكير'),
              ),
            ),
          ],
        );
      },
    );
  }
}
