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
    final color = Theme.of(context).colorScheme.primary;
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        _btn('# ', 'H1', color),
        _btn('## ', 'H2', color),
        _btn('### ', 'H3', color),
        _btn('**', 'B', color, end: '**'),
        _btn('*', 'I', color, end: '*'),
        _btn('~~', 'S', color, end: '~~'),
        _btn('`', '</>', color, end: '`'),
        _btn('```\n', '{}', color, end: '\n```'),
        _btn('- ', '•', color),
        _btn('1. ', '1.', color),
        _btn('> ', '❝', color),
        _btn('[', '🔗', color, end: '](url)'),
        _btn('![', '🖼️', color, end: '](image-url)'),
        _btn('---\n', '―', color),
      ],
    );
  }

  Widget _btn(String start, String label, Color color, {String end = ''}) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => _insert(start, end),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
