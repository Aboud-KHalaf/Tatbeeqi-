import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/features/todo/domain/entities/todo_entity.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/add_edit_todo_form.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

void showAddEditTodoBottomSheet(BuildContext context, {ToDoEntity? todo}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddEditToDoForm(initialToDo: todo),
  );
}

Future<bool> showDeleteConfirmation(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n.todoConfirmDelete),
            content: Text(l10n.todoDeleteConfirmation),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(false),
                child: Text(l10n.todoCancel),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: Text(
                  l10n.todoDelete,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
