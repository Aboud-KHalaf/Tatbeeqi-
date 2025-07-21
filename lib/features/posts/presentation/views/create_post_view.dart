import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/utils/custom_snack_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_event.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/create_post/create_post_state.dart';
import 'package:tatbeeqi/features/posts/presentation/views/post_preview_view.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_app_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_form.dart';

class CreatePostView extends StatefulWidget {
  final File? imageFile;
  final bool isArticle;

  const CreatePostView({
    super.key,
    this.imageFile,
    this.isArticle = false,
  });

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _categoryController = TextEditingController();
  final _scrollController = ScrollController();

  // State variables
  late bool _isArticle;
  final List<String> _categories = [];
  final List<String> _topics = [];
  File? _image;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _image = widget.imageFile;
    _isArticle = widget.isArticle;
    _textController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onContentChanged);
    _textController.dispose();
    _categoryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    final hasChanges = _textController.text.trim().isNotEmpty ||
        _categories.isNotEmpty ||
        _topics.isNotEmpty ||
        _image != null;

    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    HapticFeedback.lightImpact();
    final result = await UnsavedChangesDialog.show(context);
    return result ?? false;
  }

  bool get _canSubmit {
    return _textController.text.trim().isNotEmpty &&
        context.watch<PostCrudBloc>().state is! CreatePostInProgress;
  }

  bool get _canPreview {
    return _textController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: CreatePostAppBar(
          isArticle: _isArticle,
          hasUnsavedChanges: _hasUnsavedChanges,
          canPreview: _canPreview,
          onClose: () async {
            if (_hasUnsavedChanges) {
              final shouldClose = await _onWillPop();
              if (shouldClose && context.mounted) {
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
          },
          onPreview: _showPreview,
        ),
        body: BlocListener<PostCrudBloc, PostCrudState>(
          listener: _handleBlocState,
          child: Column(
            children: [
              // Loading indicator
              if (context.watch<PostCrudBloc>().state is CreatePostInProgress)
                const LinearProgressIndicator(),

              // Main content
              Expanded(
                child: CreatePostForm(
                  formKey: _formKey,
                  textController: _textController,
                  categoryController: _categoryController,
                  scrollController: _scrollController,
                  categories: _categories,
                  topics: _topics,
                  image: _image,
                  isArticle: _isArticle,
                  isSubmitting: context.watch<PostCrudBloc>().state
                      is CreatePostInProgress,
                  canSubmit: _canSubmit,
                  onAddCategory: _addCategory,
                  onRemoveCategory: _removeCategory,
                  onImagePicked: (file) {
                    setState(() => _image = file);
                    _onContentChanged();
                  },
                  onImageRemoved: () {
                    setState(() => _image = null);
                    _onContentChanged();
                  },
                  onArticleTypeChanged: (value) {
                    setState(() => _isArticle = value);
                    _onContentChanged();
                  },
                  onTopicSelected: _onTopicSelected,
                  onSubmit: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBlocState(BuildContext context, PostCrudState state) {
    if (state is CreatePostSuccess) {
      HapticFeedback.lightImpact();
      CustomSnackBar.showSuccess(
        context: context,
        message: _isArticle
            ? "Article published successfully!"
            : "Post created successfully!",
      );
      Navigator.pop(context, true);
    } else if (state is CreatePostFailure) {
      HapticFeedback.lightImpact();
      CustomSnackBar.showError(
        context: context,
        message: state.message,
      );
    }
  }

  void _addCategory(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isNotEmpty && !_categories.contains(trimmedValue)) {
      setState(() {
        _categories.add(trimmedValue);
      });
      _categoryController.clear();
      _onContentChanged();
    }
  }

  void _removeCategory(String value) {
    setState(() {
      _categories.remove(value);
    });
    _onContentChanged();
  }

  void _onTopicSelected(String topic) {
    setState(() {
      if (_topics.contains(topic)) {
        _topics.remove(topic);
      } else {
        _topics.add(topic);
      }
    });
    _onContentChanged();
  }

  void _showPreview() {
    if (!_canPreview) {
      CustomSnackBar.showWarning(
        context: context,
        message: "Add some content to preview",
      );
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PostPreviewView(
          text: _textController.text,
          image: _image,
          categories: _categories,
          topics: _topics,
          isArticle: _isArticle,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || !_canSubmit) {
      return;
    }

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

class UnsavedChangesDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 32,
        ),
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes that will be lost if you leave now.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
