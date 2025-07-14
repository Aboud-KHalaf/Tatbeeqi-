import 'package:flutter/material.dart';

class AddCommentBar extends StatefulWidget {
  final Function(String) onSubmit;
  const AddCommentBar({super.key, required this.onSubmit});

  @override
  State<AddCommentBar> createState() => _AddCommentBarState();
}

class _AddCommentBarState extends State<AddCommentBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _submitComment(),
                onChanged: (_) => setState(() {}), // Rebuild to update button state
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                return IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: value.text.isNotEmpty ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
                  onPressed: value.text.isNotEmpty ? _submitComment : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
