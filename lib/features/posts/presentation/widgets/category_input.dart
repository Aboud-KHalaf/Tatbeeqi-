import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class CategoryInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final void Function(String) onAddCategory;
  final void Function(String) onRemoveCategory;

  const CategoryInput({
    super.key,
    required this.controller,
    required this.categories,
    required this.onAddCategory,
    required this.onRemoveCategory,
  });

  // Sample existing categories for autocomplete
  static const List<String> existingCategories = [
    'Technology',
    'Science',
    'Health',
    'Education',
    'Sports',
    'Travel',
    'Food',
    'Art',
    'Music',
    'Business',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categoryInputAddCategory,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
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
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration:
                  InputDecoration(labelText: l10n.categoryInputAddCategory),
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
