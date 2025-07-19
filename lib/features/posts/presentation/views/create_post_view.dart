import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/utils/custom_snack_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_event.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_state.dart';
import 'package:tatbeeqi/features/posts/presentation/views/post_preview_view.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_editor_form.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  bool _isArticle = false;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController()
    ..value = const TextEditingValue(
      text: '',
      selection: TextSelection.collapsed(offset: 0),
    );
  final _categoryController = TextEditingController();
  final List<String> _categories = [];
  final List<String> _topics = [];
  File? _image;

  @override
  void dispose() {
    _textController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview_outlined),
            onPressed: () => _showPreview(context),
          ),
        ],
      ),
      body: BlocListener<PostCrudBloc, PostCrudState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            CustomSnackBar.showSuccess(
              context: context,
              message: "Post created successfully!",
            );
            Navigator.pop(context);
          } else if (state is CreatePostFailure) {
            CustomSnackBar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: PostEditorForm(
              formKey: _formKey,
              textController: _textController,
              categoryController: _categoryController,
              categories: _categories,
              onAddCategory: _addCategory,
              onRemoveCategory: _removeCategory,
              image: _image,
              onImagePicked: (file) => setState(() => _image = file),
              onImageRemoved: _removeImage,
              onSubmit: () => _submit(context),
              isSubmitting:
                  context.watch<PostCrudBloc>().state is CreatePostInProgress,
              isArticle: _isArticle,
              onArticleTypeChanged: (value) =>
                  setState(() => _isArticle = value),
              topics: _topics,
              onTopicSelected: _onTopicSelected,
            ),
          ),
        ),
      ),
    );
  }

  // Helper to add a category
  void _addCategory(String value) {
    if (value.trim().isNotEmpty && !_categories.contains(value.trim())) {
      setState(() {
        _categories.add(value.trim());
      });
      _categoryController.clear();
    }
  }

  // Helper to remove a category
  void _removeCategory(String value) {
    setState(() {
      _categories.remove(value);
    });
  }

  // Helper to remove the image
  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  void _onTopicSelected(String topic) {
    setState(() {
      if (_topics.contains(topic)) {
        _topics.remove(topic);
      } else {
        _topics.add(topic);
      }
    });
  }

  void _showPreview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostPreviewView(
          text: _textController.text,
          image: _image,
          categories: _categories,
          topics: _topics,
          isArticle: _isArticle,
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<PostCrudBloc>().add(
          CreatePostEvent(
            topics: _topics,
            text: _textController.text.trim(),
            categories: _categories,
            image: _image,
            isArticle: _isArticle,
          ),
        );
  }
}
