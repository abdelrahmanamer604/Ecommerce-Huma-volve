import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final int selectedCategoryId;
  final bool isProductsLoading;

  HomeSuccess({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
    this.isProductsLoading = false,
  });

  HomeSuccess copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
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
