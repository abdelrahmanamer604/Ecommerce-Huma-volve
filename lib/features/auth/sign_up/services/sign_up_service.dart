// ignore_for_file: avoid_print, unused_import
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/sign_up_model.dart';

class SignUpService {
  ApiClient apiClient;
  SignUpService(this.apiClient);

  Future<SignUpModel> signUp({
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
    final Map<String, dynamic> jsonData = response.data;
    final modelData = SignUpModel.fromJson(jsonData);

    print("User Created: ${modelData.name} - ${modelData.email}");

    return modelData;
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.registerEndpoint);
      if (response.data is List) {
        final List users = response.data as List;
        return users.any((user) =>
            user is Map &&
            user['email']?.toString().trim().toLowerCase() ==
                email.trim().toLowerCase());
      }
    } catch (_) {}
    return false;
  }
}
