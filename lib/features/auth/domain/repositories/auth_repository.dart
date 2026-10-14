import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    String avatar = 'https://picsum.photos/800',
  });

  Future<Either<Failure, bool>> isEmailRegistered(String email);

  Future<Either<Failure, UserEntity>> getProfile(String accessToken);
}
