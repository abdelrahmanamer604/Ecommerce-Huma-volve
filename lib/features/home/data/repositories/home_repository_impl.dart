import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getAllProducts(
        offset: offset,
        limit: limit,
      );
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getProductsByCategory(
        categoryId: categoryId,
        offset: offset,
        limit: limit,
      );
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
