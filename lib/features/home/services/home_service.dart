import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeService {
  final ApiClient apiClient;

  HomeService(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List data = response.data as List;
    return data
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await apiClient.dio.get(ApiEndpoints.productsEndpoint);
    final List data = response.data as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await apiClient.dio.get(
      ApiEndpoints.categoryProductsEndpoint(categoryId),
    );
    final List data = response.data as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
