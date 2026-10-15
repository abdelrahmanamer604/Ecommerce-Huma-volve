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
  final bool isLoadingMore;
  final bool hasMore;
  final int currentOffset;

  HomeSuccess({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
    this.isProductsLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentOffset = 0,
  });

  HomeSuccess copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    int? selectedCategoryId,
    bool? isProductsLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentOffset,
  }) {
    return HomeSuccess(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentOffset: currentOffset ?? this.currentOffset,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
