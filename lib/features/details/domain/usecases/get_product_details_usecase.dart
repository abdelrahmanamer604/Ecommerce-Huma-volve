import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/details_repository.dart';

class GetProductDetailsUseCase {
  final DetailsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(int id) {
    return repository.getProductById(id);
  }
}
