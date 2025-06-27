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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Add a comment...'),
            onSubmitted: (_) => _submitComment(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _submitComment,
        ),
      ],
    );
  }
}
