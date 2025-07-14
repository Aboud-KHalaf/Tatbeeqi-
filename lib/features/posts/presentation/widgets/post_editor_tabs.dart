import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'post_editor_form.dart';

class PostEditorTabs extends StatelessWidget {
  final TabController tabController;
  final TextEditingController textController;
  final TextEditingController categoryController;
  final List<String> categories;
  final void Function(String) onAddCategory;
  final void Function(String) onRemoveCategory;
  final File? image;
  final void Function(File) onImagePicked;
  final VoidCallback onImageRemoved;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const PostEditorTabs({
    super.key,
    required this.tabController,
    required this.textController,
    required this.categoryController,
    required this.categories,
    required this.onAddCategory,
    required this.onRemoveCategory,
    required this.image,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.formKey,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        PostEditorForm(
          textController: textController,
          categoryController: categoryController,
          categories: categories,
          onAddCategory: onAddCategory,
          onRemoveCategory: onRemoveCategory,
          image: image,
          onImagePicked: onImagePicked,
          onImageRemoved: onImageRemoved,
          formKey: formKey,
          onSubmit: onSubmit,
          isSubmitting: isSubmitting,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MarkdownBody(
            data: textController.text.isEmpty
                ? '*No content to preview*'
                : textController.text,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
