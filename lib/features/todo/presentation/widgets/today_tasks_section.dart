import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/todo/presentation/manager/todo_cubit.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/empty_today_tasks_widget.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/start_new_chalenge_button_widget.dart';
import 'package:tatbeeqi/features/todo/domain/entities/todo_entity.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/today_tasks_list_view_widget.dart';
 
class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const StartNewChallengeButtonWidget(),
        const SizedBox(height: 20),
        BlocBuilder<ToDoCubit, ToDoState>(builder: (context, state) {
          if (state is ToDoActionSuccessState) {
            SnackBarHelper.showSuccess(
                context: context, message: state.message!);
          } else if (state is ToDoActionFailureState) {
            SnackBarHelper.showError(
                context: context, message: state.message);
          } else if (state is ToDoErrorState) {
            return _buildErrorState(context, state.message);
          } else if (state is ToDoLoadedState) {
            final now = DateTime.now();
            final toDayToDos = state.todos.where((todo) {
              return todo.dueDate != null &&
                  todo.dueDate!.year == now.year &&
                  todo.dueDate!.month == now.month &&
                  todo.dueDate!.day == now.day;
            }).toList();

            return _buildTasksContent(context, toDayToDos, state.todos.length);
          }
          return _buildLoadingState(context);
        }),
      ],
    );
  }

  Widget _buildTasksContent(
      BuildContext context, List toDayToDos, int totalTasks) {
    if (toDayToDos.isEmpty) {
      return const EmptyToDayTasksWidget();
    }

    return ToDayTasksListViewWidget(
        toDayToDos: toDayToDos.cast<ToDoEntity>());
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 32,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(height: 8),
          Text(
            'خطأ في تحميل المهام',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onErrorContainer.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const AppLoading();
  }
}
