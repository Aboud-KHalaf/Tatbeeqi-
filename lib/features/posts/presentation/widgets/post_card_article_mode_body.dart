import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/widgets/code_block_builder_widget.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class PostCardArticleModelBody extends StatelessWidget {
  final Post post;
  const PostCardArticleModelBody({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Directionality(
      textDirection: getTextDirection(post.text),
      child: MarkdownBody(
        data: post.text,
        softLineBreak: true,
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          p: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.6,
            color: colorScheme.onSurfaceVariant,
          ),
          code: const TextStyle(backgroundColor: Colors.transparent),
          blockSpacing: 8,
        ),
        selectable: true,
        builders: {
          'code': HighlightedCodeBlockBuilder(context: context),
        },
      ),
    );
  }
}
