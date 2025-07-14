import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/create_post/create_post_state.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_editor_tabs.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<String> _categories = [];
  final List<String> _topics = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Editor'),
            Tab(text: 'Preview'),
          ],
        ),
      ),
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post created successfully!')),
            );
            Navigator.pop(context);
          } else if (state is CreatePostFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: PostEditorTabs(
              tabController: _tabController,
              textController: _textController,
              categoryController: _categoryController,
              categories: _categories,
              onAddCategory: _addCategory,
              onRemoveCategory: _removeCategory, // Pass the new method
              image: _image,
              onImagePicked: (file) => setState(() => _image = file),
              onImageRemoved: _removeImage,
              formKey: _formKey,
              onSubmit: () => _submit(context),
              isSubmitting: context.watch<CreatePostBloc>().state is CreatePostInProgress,
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

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<CreatePostBloc>().add(
          CreatePostSubmitted(
            topics: _topics,
            text: _textController.text.trim(),
            categories: _categories,
            imagePath: _image?.path,
          ),
        );
  }
}
