import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/home_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;
  List<ProductModel> _originalProducts = [];

  HomeCubit(this.homeService) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        homeService.getCategories(),
        homeService.getAllProducts(),
      ]);

      final categories = [
        CategoryModel(id: 0, name: 'All'),
        ...(results[0] as List<CategoryModel>),
      ];
      final products = results[1] as List<ProductModel>;
      _originalProducts = List.from(products);

      emit(
        HomeSuccess(
          categories: categories,
          products: products,
          selectedCategoryId: 0,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
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

    try {
      List<ProductModel> products;
      if (categoryId == 0) {
        products = await homeService.getAllProducts();
      } else {
        products = await homeService.getProductsByCategory(categoryId);
      }
      _originalProducts = List.from(products);

      emit(
        currentState.copyWith(
          selectedCategoryId: categoryId,
          products: products,
          isProductsLoading: false,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isProductsLoading: false,
        ),
      );
    }
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
