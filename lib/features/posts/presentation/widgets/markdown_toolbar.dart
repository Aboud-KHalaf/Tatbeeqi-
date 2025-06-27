import 'package:flutter/material.dart';

class MarkdownToolbar extends StatelessWidget {
  final TextEditingController controller;
  const MarkdownToolbar({super.key, required this.controller});

  void _addMarkdown(String start, String end) {
    final text = controller.text;
    final selection = controller.selection;
    final selectedText = (selection.start >= 0 && selection.end >= selection.start)
      ? text.substring(selection.start, selection.end)
      : '';
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$start$selectedText$end',
    );
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + start.length + selectedText.length + end.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Tooltip(
            message: 'Bold',
            child: IconButton(
              icon: const Icon(Icons.format_bold),
              color: colorScheme.primary,
              onPressed: () => _addMarkdown('**', '**'),
            ),
          ),
          Tooltip(
            message: 'Italic',
            child: IconButton(
              icon: const Icon(Icons.format_italic),
              color: colorScheme.primary,
              onPressed: () => _addMarkdown('_', '_'),
            ),
          ),
          Tooltip(
            message: 'Code',
            child: IconButton(
              icon: const Icon(Icons.code),
              color: colorScheme.primary,
              onPressed: () => _addMarkdown('`', '`'),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
