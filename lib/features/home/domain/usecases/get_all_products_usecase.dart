import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetAllProductsUseCase {
  final HomeRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int offset = 0,
    int limit = 10,
  }) {
    return repository.getAllProducts(offset: offset, limit: limit);
  }
}
