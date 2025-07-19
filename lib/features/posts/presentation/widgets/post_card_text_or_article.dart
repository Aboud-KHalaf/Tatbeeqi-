import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/widgets/custom_markdown_body_widget.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/views/post_details_view.dart';

class PostTextOrArticle extends StatefulWidget {
  final Post post;

  const PostTextOrArticle({
    super.key,
    required this.post,
  });

  @override
  State<PostTextOrArticle> createState() => _PostTextOrArticleState();
}

class _PostTextOrArticleState extends State<PostTextOrArticle>
    with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();

  bool get _isLongText {
    if (widget.post.isArticle && (widget.post.text.length > 100)) return true;
    return widget.post.text.length > 200;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArticle = widget.post.isArticle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        key: _key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isArticle ? _buildArticleContent() : _buildTextContent(),
          ),
          if (_isLongText)
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetailsView(post: widget.post)));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  'Read more',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Directionality(
      textDirection: getTextDirection(widget.post.text),
      child: Text(
        widget.post.text,
        maxLines: !_isLongText ? null : 5,
        overflow: !_isLongText ? null : TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildArticleContent() {
    {
      return ClipRect(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: CustomMarkDownBodyWidget(data: widget.post.text),
          ),
        ),
      );
    }
  }
}
