import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    String avatar = 'https://picsum.photos/800',
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
        avatar: avatar,
      );
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailRegistered(String email) async {
    try {
      final result = await remoteDataSource.isEmailRegistered(email);
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile(String accessToken) async {
    try {
      final result = await remoteDataSource.getProfile(accessToken);
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
