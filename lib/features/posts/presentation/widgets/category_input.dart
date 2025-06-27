import 'package:flutter/material.dart';

class CategoryInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final Function(String) onAddCategory;
  const CategoryInput({super.key, required this.controller, required this.categories, required this.onAddCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Add Category'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onAddCategory(value.trim());
              controller.clear();
            }
          },
        ),
        Wrap(
          spacing: 8.0,
          children: categories.map((cat) => Chip(label: Text(cat))).toList(),
        ),
      ],
    );
  }
}
