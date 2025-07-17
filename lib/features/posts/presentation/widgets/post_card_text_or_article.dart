import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_article_mode_body.dart';

class PostTextOrArticle extends StatefulWidget {
  final Post post;

  const PostTextOrArticle({super.key, required this.post});

  @override
  State<PostTextOrArticle> createState() => _PostTextOrArticleState();
}

class _PostTextOrArticleState extends State<PostTextOrArticle> {
  final GlobalKey _key = GlobalKey();
  bool _isExpanded = false;
  bool _isLongText = false;

  @override
  void initState() {
    super.initState();
    _isLongText = widget.post.text.length > 200;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;
    if (widget.post.isArticle) {
      content = ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: _isExpanded ? double.infinity : 200.0),
        child: ClipRect(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: PostCardArticleModelBody(post: widget.post),
          ),
        ),
      );
    } else {
      content = Text(
        widget.post.text,
        maxLines: _isExpanded ? null : 5,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        key: _key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content,
          if (_isLongText)
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
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
}
