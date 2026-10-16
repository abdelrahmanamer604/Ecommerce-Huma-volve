import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/failure/failure.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/details_repository.dart';
import '../datasources/details_remote_data_source.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  final DetailsRemoteDataSource remoteDataSource;

  DetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
