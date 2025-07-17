import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class UploadImageUseCase {
  final PostRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Failure, String>> call(File image) async {
    return await repository.uploadPostImage(image);
  }
}
