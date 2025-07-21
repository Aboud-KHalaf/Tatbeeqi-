import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/views/post_details_view.dart';

class PostText extends StatefulWidget {
  final Post post;

  const PostText({
    super.key,
    required this.post,
  });

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();

  bool get _isLongText {
    return widget.post.text.length > 200;
  }

  @override
  Widget build(BuildContext context) {
    bool isArticle = widget.post.isArticle;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        key: _key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _buildTextContent(),
          ),
          if (_isLongText || isArticle)
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetailsView(post: widget.post)));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  isArticle ? "Show Details" : 'Read more',
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
}
