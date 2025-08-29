import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class PostPreviewView extends StatelessWidget {
  final String text;
  final File? image;
  final List<String> categories;
  final List<String> topics;
  final bool isArticle;

  const PostPreviewView({
    super.key,
    required this.text,
    this.image,
    required this.categories,
    required this.topics,
    required this.isArticle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Create a dummy post for preview purposes
    final previewPost = Post(
      id: 'preview_post',
      authorId: 'preview_user_id',
      authorName: 'You',
      authorAvatarUrl: '', // Optional: Add a default avatar URL
      text: text,
      imageUrl:
          image?.path, // This will be a local path, PostCard expects a URL
      categories: categories,
      topics: topics,
      isArticle: isArticle,
      createdAt: DateTime.now(),
      likesCount: 0,
      commentsCount: 0,
      isLiked: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createPostPreview),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: PostCard(post: previewPost),
      ),
    );
  }
}
