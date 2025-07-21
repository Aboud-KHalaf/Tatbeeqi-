import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_image_section.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_text_field.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_category_input.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_markdown_toolbar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/publish_button.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/topic_selector.dart';

class CreatePostForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final TextEditingController categoryController;
  final ScrollController scrollController;
  final List<String> categories;
  final List<String> topics;
  final File? image;
  final bool isArticle;
  final bool isSubmitting;
  final bool canSubmit;
  final Function(String) onAddCategory;
  final Function(String) onRemoveCategory;
  final Function(File) onImagePicked;
  final VoidCallback onImageRemoved;
  final Function(bool) onArticleTypeChanged;
  final Function(String) onTopicSelected;
  final VoidCallback onSubmit;

  const CreatePostForm({
    super.key,
    required this.formKey,
    required this.textController,
    required this.categoryController,
    required this.scrollController,
    required this.categories,
    required this.topics,
    required this.image,
    required this.isArticle,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onAddCategory,
    required this.onRemoveCategory,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.onArticleTypeChanged,
    required this.onTopicSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post type toggle
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          isArticle
                              ? Icons.article_outlined
                              : Icons.chat_bubble_outline,
                          key: ValueKey(isArticle),
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Post Type',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: isArticle,
                        onChanged: onArticleTypeChanged,
                      ),
                      const SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          isArticle ? 'Article' : 'Post',
                          key: ValueKey(isArticle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isArticle
                    ? PostMarkdownToolbar(
                        key: const ValueKey('markdown-toolbar'),
                        controller: textController,
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('no-toolbar'),
                      ),
              ),

              const SizedBox(height: 16),

              // Main content text field
              CreatePostTextField(
                controller: textController,
                isArticle: isArticle,
              ),

              const SizedBox(height: 16),

              // Image section
              ImageSection(
                image: image,
                onImagePicked: onImagePicked,
                onImageRemoved: onImageRemoved,
              ),

              const SizedBox(height: 16),

              // Categories section
              CategorySection(
                controller: categoryController,
                categories: categories,
                onAddCategory: onAddCategory,
                onRemoveCategory: onRemoveCategory,
              ),

              const SizedBox(height: 16),

              // Topics section
              TopicSection(
                topics: topics,
                onTopicSelected: onTopicSelected,
              ),

              const SizedBox(height: 24),

              // Publish button
              PublishButton(
                isArticle: isArticle,
                canSubmit: canSubmit,
                isSubmitting: isSubmitting,
                onSubmit: onSubmit,
              ),

              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
