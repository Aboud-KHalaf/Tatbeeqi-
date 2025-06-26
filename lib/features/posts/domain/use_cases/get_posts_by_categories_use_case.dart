import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/domain/repositories/post_repository.dart';

class GetPostsByCategoriesUseCase {
  final PostRepository repository;

  GetPostsByCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(List<String> categories, {int limit = 10}) async {
    return await repository.getPostsByCategories(categories, limit: limit);
  }
}
