import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
                context.push(
                  AppRoutes.postDetails,
                  extra: PostDetailsArgs(post: widget.post),
                );
              },
              child: Row(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      isArticle
                          ? l10n.postCardShowDetails
                          : l10n.postCardReadMore,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
