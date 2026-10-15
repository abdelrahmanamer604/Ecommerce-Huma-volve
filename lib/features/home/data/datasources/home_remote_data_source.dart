import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getAllProducts({
    int offset = 0,
    int limit = 10,
  });
  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = 10,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List data = response.data as List;
    return data
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await apiClient.dio.get(
      ApiEndpoints.productsEndpoint,
      queryParameters: {
        'offset': offset,
        'limit': limit,
      },
    );
    final List data = response.data as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await apiClient.dio.get(
      ApiEndpoints.categoryProductsEndpoint(categoryId),
      queryParameters: {
        'offset': offset,
        'limit': limit,
      },
    );
    final List data = response.data as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
