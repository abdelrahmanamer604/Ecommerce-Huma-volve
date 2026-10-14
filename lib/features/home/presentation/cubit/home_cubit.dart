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

  List<ProductEntity> _originalProducts = [];

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getAllProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    final categoriesResult = await getCategoriesUseCase();
    final productsResult = await getAllProductsUseCase();

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

    emit(
      currentState.copyWith(
        selectedCategoryId: categoryId,
        isProductsLoading: true,
      ),
    );

    final result = categoryId == 0
        ? await getAllProductsUseCase()
        : await getProductsByCategoryUseCase(categoryId);

    result.fold(
      (failure) => emit(currentState.copyWith(isProductsLoading: false)),
      (products) {
        _originalProducts = List.from(products);
        emit(
          currentState.copyWith(
            selectedCategoryId: categoryId,
            products: products,
            isProductsLoading: false,
          ),
        );
      },
    );
  }

  void searchProducts(String query) {
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
