import 'package:flutter/material.dart';

class PostMarkdownToolbar extends StatelessWidget {
  final TextEditingController controller;
  const PostMarkdownToolbar({super.key, required this.controller});

  void _insert(String start, String end) {
    final text = controller.text;
    final selection = controller.selection;
    final before = text.substring(0, selection.start);
    final selected = text.substring(selection.start, selection.end);
    final after = text.substring(selection.end);
    controller.text = before + start + selected + end + after;
    controller.selection = TextSelection.collapsed(offset: (before + start + selected + end).length);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _btn(context, tooltip: 'Header 1', label: 'H1', start: '# '),
        _btn(context, tooltip: 'Header 2', label: 'H2', start: '## '),
        _btn(context, tooltip: 'Header 3', label: 'H3', start: '### '),
        _btn(context, tooltip: 'Bold', icon: Icons.format_bold, start: '**', end: '**'),
        _btn(context, tooltip: 'Italic', icon: Icons.format_italic, start: '*', end: '*'),
        _btn(context, tooltip: 'Strikethrough', icon: Icons.format_strikethrough, start: '~~', end: '~~'),
        _btn(context, tooltip: 'Inline Code', icon: Icons.code, start: '`', end: '`'),
        _btn(context, tooltip: 'Code Block', icon: Icons.data_object, start: '```\n', end: '\n```'),
        _btn(context, tooltip: 'Unordered List', icon: Icons.format_list_bulleted, start: '- '),
        _btn(context, tooltip: 'Ordered List', icon: Icons.format_list_numbered, start: '1. '),
        _btn(context, tooltip: 'Quote', icon: Icons.format_quote, start: '> '),
        _btn(context, tooltip: 'Link', icon: Icons.link, start: '[', end: '](url)'),
        _btn(context, tooltip: 'Image', icon: Icons.image_outlined, start: '![', end: '](image-url)'),
        _btn(context, tooltip: 'Horizontal Rule', icon: Icons.horizontal_rule, start: '---\n'),
      ],
    );
  }

  Widget _btn(
    BuildContext context, {
    required String tooltip,
    String? label,
    IconData? icon,
    required String start,
    String end = '',
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _insert(start, end),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: icon != null
                ? Icon(icon, size: 20, color: colorScheme.onSurfaceVariant)
                : Text(
                    label!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
