import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/utils/app_methods.dart';
import 'package:tatbeeqi/features/todo/domain/entities/todo_entity.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/todo_check_box_widget.dart';

class ToDayTaskListViewItemWidget extends StatelessWidget {
  const ToDayTaskListViewItemWidget({
    super.key,
    required this.task,
  });

  final ToDoEntity task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final importanceColor = getColorByImportance(task.importance);
    final background = task.isCompleted
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerHighest;
    final borderColor = colorScheme.outlineVariant.withOpacity(0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onLongPress: () => showAddEditTodoBottomSheet(context, todo: task),
          onDoubleTap: () => showAddEditTodoBottomSheet(context, todo: task),
          child: Container(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: IntrinsicHeight(
              child: Row(
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading colored dot
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? borderColor : importanceColor,
                      shape: BoxShape.circle,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 6.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Texts
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  task.title,
                                  style: textTheme.titleSmall?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? colorScheme.onSurface.withOpacity(0.6)
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (task.description.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      task.description,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: task.isCompleted
                                            ? colorScheme.onSurface
                                                .withOpacity(0.45)
                                            : colorScheme.onSurfaceVariant,
                                        height: 1.2,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Trailing checkbox
                          ToDoCheckBoxWidget(task: task),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
