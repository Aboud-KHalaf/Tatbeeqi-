import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final Function(File) onImagePicked;
  const ImagePickerWidget({super.key, required this.image, required this.onImagePicked});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image != null)
          Image.file(image!, height: 150),
        ElevatedButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Pick Image'),
          onPressed: () => _pickImage(context),
        ),
      ],
    );
  }
}
