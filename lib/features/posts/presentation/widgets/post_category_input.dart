import 'package:flutter/material.dart';

class PostCategoryInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final void Function(String) onAddCategory;

  const PostCategoryInput({super.key, required this.controller, required this.categories, required this.onAddCategory});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التصنيفات', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'أضف تصنيفًا',
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: onAddCategory,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () => onAddCategory(controller.text),
              child: const Text('إضافة'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: categories.map((cat) => Chip(label: Text(cat), backgroundColor: colorScheme.secondary.withOpacity(0.18))).toList(),
        ),
      ],
    );
  }
}
