import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    int offset = 0,
    int limit = 10,
  });
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = 10,
  });
}
