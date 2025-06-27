import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostImagePicker extends StatelessWidget {
  final File? image;
  final void Function(File) onImagePicked;

  const PostImagePicker({super.key, required this.image, required this.onImagePicked});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      onImagePicked(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('صورة المنشور', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image!, width: 80, height: 80, fit: BoxFit.cover),
              ),
            if (image != null) const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () => _pickImage(context),
              icon: const Icon(Icons.image),
              label: Text(image == null ? 'إضافة صورة' : 'تغيير الصورة'),
            ),
          ],
        ),
      ],
    );
  }
}
