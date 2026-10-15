import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  static const int _pageSize = 10;
  List<ProductEntity> _originalProducts = [];
  String _currentSearchQuery = '';

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getAllProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    _currentSearchQuery = '';

    final categoriesResult = await getCategoriesUseCase();
    final productsResult =
        await getAllProductsUseCase(offset: 0, limit: _pageSize);

    categoriesResult.fold(
      (failure) => emit(HomeError(failure.failureMessage)),
      (categories) {
        productsResult.fold(
          (failure) => emit(HomeError(failure.failureMessage)),
          (products) {
            final allCategories = [
              const CategoryEntity(id: 0, name: 'All'),
              ...categories,
            ];
            _originalProducts = List.from(products);
            emit(
              HomeSuccess(
                categories: allCategories,
                products: products,
                selectedCategoryId: 0,
                currentOffset: 0,
                hasMore: products.length == _pageSize,
                isLoadingMore: false,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> selectCategory(int categoryId) async {
    final currentState = state;
    if (currentState is! HomeSuccess) return;
    if (currentState.selectedCategoryId == categoryId &&
        !currentState.isProductsLoading) {
      return;
    }

    _currentSearchQuery = '';
    emit(
      currentState.copyWith(
        selectedCategoryId: categoryId,
        isProductsLoading: true,
        currentOffset: 0,
      ),
    );

    final result = categoryId == 0
        ? await getAllProductsUseCase(offset: 0, limit: _pageSize)
        : await getProductsByCategoryUseCase(
            categoryId: categoryId,
            offset: 0,
            limit: _pageSize,
          );

    result.fold(
      (failure) => emit(currentState.copyWith(isProductsLoading: false)),
      (products) {
        _originalProducts = List.from(products);
        emit(
          currentState.copyWith(
            selectedCategoryId: categoryId,
            products: products,
            isProductsLoading: false,
            currentOffset: 0,
            hasMore: products.length == _pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is! HomeSuccess) return;
    if (currentState.isLoadingMore ||
        !currentState.hasMore ||
        currentState.isProductsLoading ||
        _currentSearchQuery.trim().isNotEmpty) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextOffset = currentState.currentOffset + _pageSize;

    final result = currentState.selectedCategoryId == 0
        ? await getAllProductsUseCase(offset: nextOffset, limit: _pageSize)
        : await getProductsByCategoryUseCase(
            categoryId: currentState.selectedCategoryId,
            offset: nextOffset,
            limit: _pageSize,
          );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (newProducts) {
        final updatedProducts = List<ProductEntity>.from(currentState.products)
          ..addAll(newProducts);
        _originalProducts = List.from(updatedProducts);
        emit(
          currentState.copyWith(
            products: updatedProducts,
            currentOffset: nextOffset,
            hasMore: newProducts.length == _pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  void searchProducts(String query) {
    _currentSearchQuery = query;
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    if (query.trim().isEmpty) {
      emit(currentState.copyWith(products: _originalProducts));
      return;
    }

    final filtered = _originalProducts.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(currentState.copyWith(products: filtered));
  }
}
