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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء منشور'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'المحرّر'),
            Tab(text: 'المعاينة'),
          ],
        ),
      ),
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إنشاء المنشور بنجاح')),
            );
            Navigator.pop(context);
          } else if (state is CreatePostFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ: ${state.message}')),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: PostEditorTabs(
                  tabController: _tabController,
                  textController: _textController,
                  categoryController: _categoryController,
                  categories: _categories,
                  onAddCategory: _addCategory,
                  image: _image,
                  onImagePicked: (file) => setState(() => _image = file),
                  formKey: _formKey,
                  onSubmit: () => _submit(context),
                  isSubmitting: context.watch<CreatePostBloc>().state is CreatePostInProgress,
                ),
              ),
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
