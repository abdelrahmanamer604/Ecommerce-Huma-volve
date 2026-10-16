import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class DetailsRepository {
  Future<Either<Failure, ProductEntity>> getProductById(int id);
}
