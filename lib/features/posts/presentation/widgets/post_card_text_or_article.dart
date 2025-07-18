import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_article_mode_body.dart';

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
  bool _isExpanded = false;

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
                setState(() => _isExpanded = !_isExpanded);
                if (!_isExpanded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scrollable.ensureVisible(
                      _key.currentContext!,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _isExpanded ? 'Show less' : 'Read more',
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
    return Text(
      widget.post.text,
      maxLines: _isExpanded ? null : 5,
      overflow: _isExpanded ? null : TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildArticleContent() {
    if (_isExpanded) {
      return PostCardArticleModelBody(post: widget.post);
    } else {
      return ClipRect(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: PostCardArticleModelBody(post: widget.post),
          ),
        ),
      );
    }
  }
}
