import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final Function(String) onAddCategory;
  final Function(String) onRemoveCategory;

  const CategorySection({
    super.key,
    required this.controller,
    required this.categories,
    required this.onAddCategory,
    required this.onRemoveCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.label_outline,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Add category field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Add a category...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onAddCategory(controller.text);
                }
              },
            ),
          ),
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onAddCategory(value);
            }
          },
        ),

        const SizedBox(height: 12),

        // Category chips
        if (categories.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              return Chip(
                label: Text(category),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => onRemoveCategory(category),
                backgroundColor: colorScheme.secondaryContainer,
                labelStyle: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}


// class PostCategoryInput extends StatelessWidget {
//   final TextEditingController controller;
//   final List<String> categories;
//   final void Function(String) onAddCategory;
//   final void Function(String) onRemoveCategory;

//   const PostCategoryInput({
//     super.key,
//     required this.controller,
//     required this.categories,
//     required this.onAddCategory,
//     required this.onRemoveCategory,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Categories',
//           style: theme.textTheme.titleMedium
//               ?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   hintText: 'Add a category...',
//                   filled: true,
//                   fillColor: colorScheme.surfaceContainerHighest
//                       .withValues(alpha: 0.5),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 ),
//                 onSubmitted: onAddCategory,
//               ),
//             ),
//             const SizedBox(width: 8),
//             IconButton.filled(
//               style: IconButton.styleFrom(
//                 backgroundColor: colorScheme.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () => onAddCategory(controller.text),
//               icon: Icon(Icons.add, color: colorScheme.onPrimary),
//             ),
//           ],
//         ),
//         if (categories.isNotEmpty) const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: categories
//               .map((cat) => Chip(
//                     label: Text(cat),
//                     backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
//                     onDeleted: () => onRemoveCategory(cat),
//                     deleteIcon:
//                         Icon(Icons.close, size: 16, color: colorScheme.primary),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       side: BorderSide(
//                           color: colorScheme.primary.withValues(alpha: 0.2)),
//                     ),
//                   ))
//               .toList(),
//         ),
//       ],
//     );
//   }
// }
