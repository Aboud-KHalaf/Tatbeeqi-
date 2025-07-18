import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tatbeeqi/core/widgets/code_block_builder_widget.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_action_buttons.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_categories.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_header.dart';

class PostDetailsView extends StatefulWidget {
  final Post post;
  final bool showMore;

  const PostDetailsView({
    super.key,
    required this.post,
    this.showMore = true,
  });

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView>
    with SingleTickerProviderStateMixin {
  late final DraggableScrollableController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();

    if (widget.showMore && widget.post.imageUrl == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sheetController.animateTo(
          1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          if (widget.post.imageUrl == null) ...[
            Positioned.fill(
              child: CustomPaint(
                painter: _ColorfulBackgroundPainter(isDark: isDark),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.2),
                ),
              ),
            ),
          ],
          if (widget.post.imageUrl != null)
            Positioned.fill(
              child: Hero(
                tag: widget.post.imageUrl!,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 4,
                  child: CachedNetworkImage(
                    imageUrl: widget.post.imageUrl!,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.25,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.4),
                              ]
                            : [
                                Colors.white.withOpacity(0.8),
                                Colors.white.withOpacity(0.5),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostCardHeader(post: widget.post),
                          const SizedBox(height: 12),
                          if (widget.post.text.isNotEmpty)
                            widget.post.isArticle
                                ? MarkdownBody(
                                    data: widget.post.text,
                                    styleSheet:
                                        MarkdownStyleSheet.fromTheme(theme)
                                            .copyWith(
                                      p: theme.textTheme.bodyLarge?.copyWith(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        height: 1.6,
                                      ),
                                    ),
                                    builders: {
                                      'code': HighlightedCodeBlockBuilder(
                                          context: context),
                                    },
                                  )
                                : Text(
                                    widget.post.text,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                          const SizedBox(height: 12),
                          PostCardCategories(
                              categories: widget.post.categories),
                          const SizedBox(height: 12),
                          PostCardActionButtons(post: widget.post),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ColorfulBackgroundPainter extends CustomPainter {
  final bool isDark;

  _ColorfulBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = isDark
        ? Colors.pinkAccent.withOpacity(0.2)
        : Colors.pink.withOpacity(0.2);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 80, paint);

    paint.color = isDark
        ? Colors.cyanAccent.withOpacity(0.2)
        : Colors.blueAccent.withOpacity(0.2);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.2), 100, paint);

    paint.color = isDark
        ? Colors.amberAccent.withOpacity(0.2)
        : Colors.orangeAccent.withOpacity(0.2);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 90, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
