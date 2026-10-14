import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    String avatar = 'https://picsum.photos/800',
  });

  Future<bool> isEmailRegistered(String email);

  Future<UserModel> getProfile(String accessToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": email, "password": password},
    );
    return AuthTokenModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    String avatar = 'https://picsum.photos/800',
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.registerEndpoint,
      data: {
        "name": name,
        "email": email,
        "password": password,
        "avatar": avatar,
      },
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    final response = await apiClient.dio.get(ApiEndpoints.registerEndpoint);
    if (response.data is List) {
      final List users = response.data as List;
      return users.any((user) =>
          user is Map &&
          user['email']?.toString().trim().toLowerCase() ==
              email.trim().toLowerCase());
    }
    return false;
  }

  @override
  Future<UserModel> getProfile(String accessToken) async {
    final response = await apiClient.dio.get(
      ApiEndpoints.profileEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
