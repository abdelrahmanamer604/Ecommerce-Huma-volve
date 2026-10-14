import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsByCategoryUseCase {
  final HomeRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(int categoryId) {
    return repository.getProductsByCategory(categoryId);
  }
}
