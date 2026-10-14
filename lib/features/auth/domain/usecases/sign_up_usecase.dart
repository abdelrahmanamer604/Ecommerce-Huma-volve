import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
    String avatar = 'https://picsum.photos/800',
  }) {
    return repository.signUp(
      name: name,
      email: email,
      password: password,
      avatar: avatar,
    );
  }
}
