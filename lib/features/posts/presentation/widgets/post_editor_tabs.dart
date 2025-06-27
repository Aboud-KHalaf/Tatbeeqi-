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
  final File? image;
  final void Function(File) onImagePicked;
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
    required this.image,
    required this.onImagePicked,
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
          image: image,
          onImagePicked: onImagePicked,
          formKey: formKey,
          onSubmit: onSubmit,
          isSubmitting: isSubmitting,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Markdown(
            data: textController.text.isEmpty
                ? '*(لا يوجد محتوى للمعاينة)*'
                : textController.text,
            styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
          ),
        ),
      ],
    );
  }
}
