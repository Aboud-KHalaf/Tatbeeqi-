import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/widgets/colorful_background_painter.dart';
import 'package:tatbeeqi/core/widgets/custom_markdown_body_widget.dart';
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

    if (widget.showMore) {
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
                painter: ColorfulBackgroundPainter(isDark: isDark),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.2),
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
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
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
                                Colors.black.withValues(alpha: 0.6),
                                Colors.black.withValues(alpha: 0.4),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.8),
                                Colors.white.withValues(alpha: 0.5),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
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
                                ? CustomMarkDownBodyWidget(
                                    data: widget.post.text)
                                : Directionality(
                                    textDirection:
                                        getTextDirection(widget.post.text),
                                    child: Text(
                                      widget.post.text,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
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
