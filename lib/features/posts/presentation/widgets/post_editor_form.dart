import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_markdown_toolbar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_category_input.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_image_picker.dart';

class PostEditorForm extends StatelessWidget {
  final TextEditingController textController;
  final TextEditingController categoryController;
  final List<String> categories;
  final void Function(String) onAddCategory;
  final File? image;
  final void Function(File) onImagePicked;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const PostEditorForm({
    super.key,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PostMarkdownToolbar(controller: textController),
            const SizedBox(height: 12),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'عن ماذا تريد أن تكتب؟',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.2),
              ),
              maxLines: 8,
              validator: (v) => v!.trim().isEmpty ? 'الرجاء كتابة نص' : null,
            ),
            const SizedBox(height: 18),
            PostCategoryInput(
              controller: categoryController,
              categories: categories,
              onAddCategory: onAddCategory,
            ),
            const SizedBox(height: 18),
            PostImagePicker(
              image: image,
              onImagePicked: onImagePicked,
            ),
            const SizedBox(height: 28),
            BlocBuilder(
              bloc: BlocProvider.of(context),
              builder: (context, state) => SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isSubmitting ? null : onSubmit,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('نشر', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
