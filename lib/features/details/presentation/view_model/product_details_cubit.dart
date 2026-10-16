import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_states.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsCubit({required this.getProductDetailsUseCase})
      : super(ProductDetailsInitial());

  void setProduct(ProductEntity product) {
    emit(ProductDetailsSuccess(product));
  }

  Future<void> getProductDetails(int id) async {
    emit(ProductDetailsLoading());
    final result = await getProductDetailsUseCase(id);
    result.fold(
      (failure) => emit(ProductDetailsError(failure.failureMessage)),
      (product) => emit(ProductDetailsSuccess(product)),
    );
  }
}
