import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/todo/domain/entities/todo_entity.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/add_edit_todo_form.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarMethod(
    {required String message,
    required BuildContext context,
    required bool isError}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

/////
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
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.todoCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
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
