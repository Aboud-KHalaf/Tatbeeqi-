import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/widgets/custom_markdown_body_widget.dart';

class ReadingContentWidget extends StatelessWidget {
  final String content;
  final String? title;

  const ReadingContentWidget({
    super.key,
    required this.content,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: CustomMarkDownBodyWidget(
        data: content,
      ),
    );
  }
}
