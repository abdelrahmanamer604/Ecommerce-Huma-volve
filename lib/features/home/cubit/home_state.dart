import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final int selectedCategoryId; // 0 means 'All'
  final bool isProductsLoading;

  HomeSuccess({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
    this.isProductsLoading = false,
  });

  HomeSuccess copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    int? selectedCategoryId,
    bool? isProductsLoading,
  }) {
    return HomeSuccess(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
