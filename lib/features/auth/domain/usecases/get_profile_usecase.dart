import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String accessToken) {
    return repository.getProfile(accessToken);
  }
}
