import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostImagePicker extends StatelessWidget {
  final File? image;
  final void Function(File) onImagePicked;
  final VoidCallback onImageRemoved;

  const PostImagePicker({
    super.key,
    required this.image,
    required this.onImagePicked,
    required this.onImageRemoved,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      onImagePicked(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cover Image (Optional)',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (image == null)
          _buildPicker(context, colorScheme)
        else
          _buildPreview(context, colorScheme),
      ],
    );
  }

  Widget _buildPicker(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 40, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _pickImage(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Image'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, ColorScheme colorScheme) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: FileImage(image!),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Change'),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                onPressed: onImageRemoved,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
