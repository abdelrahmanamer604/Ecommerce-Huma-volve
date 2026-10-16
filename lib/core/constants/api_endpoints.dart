class ApiEndpoints {
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/users/';
  static const String profileEndpoint = '/auth/profile';


  static const String categoriesEndpoint = '/categories';
  static const String productsEndpoint = '/products';
  static String categoryProductsEndpoint(int categoryId) =>
      '/categories/$categoryId/products';
  static String singleProductEndpoint(int id) => '/products/$id';
}
