import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/category_input.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_markdown_toolbar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_image_picker.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/topic_selector.dart';

class PostEditorForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final TextEditingController categoryController;
  final List<String> categories;
  final void Function(String) onAddCategory;
  final void Function(String) onRemoveCategory;
  final File? image;
  final void Function(File) onImagePicked;
  final VoidCallback onImageRemoved;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  final bool isArticle;
  final ValueChanged<bool> onArticleTypeChanged;
  final List<String> topics;
  final Function(String) onTopicSelected;

  const PostEditorForm({
    super.key,
    required this.formKey,
    required this.textController,
    required this.categoryController,
    required this.categories,
    required this.onAddCategory,
    required this.onRemoveCategory,
    required this.image,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.onSubmit,
    required this.isSubmitting,
    required this.isArticle,
    required this.onArticleTypeChanged,
    required this.topics,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('This is an article'),
              value: isArticle,
              onChanged: onArticleTypeChanged,
              secondary: const Icon(Icons.article_outlined),
            ),
            if (isArticle) PostMarkdownToolbar(controller: textController),
            const SizedBox(height: 12),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'What do you want to write about?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              maxLines: 8,
              minLines: 6,
              validator: (v) =>
                  v!.trim().isEmpty ? 'Please enter some text' : null,
            ),
            const SizedBox(height: 18),
            CategoryInput(
              controller: categoryController,
              categories: categories,
              onAddCategory: onAddCategory,
              onRemoveCategory: onRemoveCategory,
              // TODO: Fetch existing categories
              existingCategories: const ['Flutter', 'Dart', 'Firebase'],
            ),
            const SizedBox(height: 16),
            TopicSelector(
              // TODO: Fetch existing topics
              availableTopics: const ['Technology', 'Programming', 'News'],
              selectedTopics: topics,
              onTopicSelected: onTopicSelected,
            ),
            const SizedBox(height: 18),
            PostImagePicker(
              image: image,
              onImagePicked: onImagePicked,
              onImageRemoved: onImageRemoved,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'Publish',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16), // Add some padding at the bottom
          ],
        ),
      ),
    );
  }
}
