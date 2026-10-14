import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
