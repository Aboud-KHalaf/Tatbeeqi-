import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_state.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _categoriesController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<CreatePostBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Post')),
        body: BlocListener<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post created successfully!')),
              );
              Navigator.of(context).pop();
            } else if (state is CreatePostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildMarkdownToolbar(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'What\'s on your mind?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter some text' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoriesController,
                    decoration: const InputDecoration(
                      labelText: 'Categories (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildImagePicker(),
                  const SizedBox(height: 24),
                  BlocBuilder<CreatePostBloc, CreatePostState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is CreatePostInProgress
                            ? null
                            : () => _submitPost(context),
                        child: state is CreatePostInProgress
                            ? const CircularProgressIndicator()
                            : const Text('Post'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownToolbar() {
    // A simple placeholder for a Markdown toolbar
    return Wrap(
      spacing: 8.0,
      children: [
        IconButton(icon: const Icon(Icons.format_bold), onPressed: () => _insertMarkdown('**', '**')),
        IconButton(icon: const Icon(Icons.format_italic), onPressed: () => _insertMarkdown('*', '*')),
        IconButton(icon: const Icon(Icons.link), onPressed: () => _insertMarkdown('[', '](url)')),
      ],
    );
  }

  void _insertMarkdown(String start, String end) {
    final text = _textController.text;
    final selection = _textController.selection;
    final newText = text.substring(0, selection.start) +
        start +
        text.substring(selection.start, selection.end) +
        end +
        text.substring(selection.end);
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + start.length),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        _image == null
            ? const Text('No image selected.')
            : Image.file(_image!),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Pick Image'),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitPost(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final categories = _categoriesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      context.read<CreatePostBloc>().add(CreatePostSubmitted(
            text: _textController.text,
            categories: categories,
            imagePath: _image?.path,
          ));
    }
  }
}
