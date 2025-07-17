import 'package:flutter/material.dart';

class CategoryInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final Function(String) onAddCategory;
  final Function(String) onRemoveCategory;
  final List<String> existingCategories;

  const CategoryInput({
    super.key,
    required this.controller,
    required this.categories,
    required this.onAddCategory,
    required this.onRemoveCategory,
    required this.existingCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return existingCategories.where((option) => option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            onAddCategory(selection);
            controller.clear();
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Add Category'),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onAddCategory(value.trim());
                  textEditingController.clear();
                }
              },
            );
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: categories
              .map((cat) => Chip(
                    label: Text(cat),
                    onDeleted: () => onRemoveCategory(cat),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
