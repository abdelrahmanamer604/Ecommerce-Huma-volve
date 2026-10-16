import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../home/data/models/product_model.dart';

abstract class DetailsRemoteDataSource {
  Future<ProductModel> getProductById(int id);
}

class DetailsRemoteDataSourceImpl implements DetailsRemoteDataSource {
  final ApiClient apiClient;

  DetailsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await apiClient.dio.get(
      ApiEndpoints.singleProductEndpoint(id),
    );
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }
}
