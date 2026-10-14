import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class CheckEmailAvailabilityUseCase {
  final AuthRepository repository;

  CheckEmailAvailabilityUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.isEmailRegistered(email);
  }
}
