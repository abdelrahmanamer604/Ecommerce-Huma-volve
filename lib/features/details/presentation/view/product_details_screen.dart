import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/dummy_data.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routing.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/datasources/details_remote_data_source.dart';
import '../../data/repositories/details_repository_impl.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../view_model/product_details_cubit.dart';
import '../view_model/product_details_states.dart';
import 'widgets/color_selector.dart';
import 'widgets/share_product_button.dart';
import 'widgets/size_selector.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final Product? product;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = DetailsRemoteDataSourceImpl(ApiClient());
    final repository = DetailsRepositoryImpl(remoteDataSource);
    final useCase = GetProductDetailsUseCase(repository);

    return BlocProvider(
      create: (context) {
        final cubit = ProductDetailsCubit(getProductDetailsUseCase: useCase);
        final id = int.tryParse(productId) ?? 0;
        cubit.getProductDetails(id);
        return cubit;
      },
      child: _ProductDetailsView(
        productId: productId,
        initialProduct: product,
      ),
    );
  }
}

class _ProductDetailsView extends StatefulWidget {
  final String productId;
  final Product? initialProduct;

  const _ProductDetailsView({
    required this.productId,
    this.initialProduct,
  });

  @override
  State<_ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<_ProductDetailsView> {
  Color? _selectedColor;
  String? _selectedSize;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = dummyFavorites.any((p) => p.id == widget.productId);
  }

  void _handleBackNavigation(BuildContext context) {
    if (widget.initialProduct != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(AppRouting.mainNavigation);
    }
  }

  void _toggleFavorite(Product currentProduct) {
    setState(() {
      if (_isFavorite) {
        dummyFavorites.removeWhere((p) => p.id == widget.productId);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currentProduct.name} removed from favorites'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.grey.shade800,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        dummyFavorites.add(currentProduct);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currentProduct.name} added to favorites!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppTheme.accent,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.initialProduct != null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(AppRouting.mainNavigation);
      },
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          Product? currentProduct;
          if (state is ProductDetailsSuccess) {
            currentProduct = state.product.toProduct();
          } else {
            currentProduct = widget.initialProduct;
          }

          if (state is ProductDetailsLoading && currentProduct == null) {
            return const Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            );
          }

          if (state is ProductDetailsError && currentProduct == null) {
            return Scaffold(
              backgroundColor: AppTheme.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () => _handleBackNavigation(context),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: AppTheme.error),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load product details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          final id = int.tryParse(widget.productId) ?? 0;
                          context
                              .read<ProductDetailsCubit>()
                              .getProductDetails(id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (currentProduct == null) {
            return const Scaffold(
              body: Center(child: Text('Product not found')),
            );
          }

          _selectedColor ??= currentProduct.colors.isNotEmpty
              ? currentProduct.colors.first
              : Colors.black;
          _selectedSize ??= currentProduct.sizes.isNotEmpty
              ? currentProduct.sizes.first
              : 'M';

          return Scaffold(
            backgroundColor: AppTheme.background,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  backgroundColor: AppTheme.background,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16),
                    ),
                    onPressed: () => _handleBackNavigation(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: _isFavorite
                              ? AppTheme.accent
                              : Colors.grey.shade700,
                        ),
                      ),
                      onPressed: () => _toggleFavorite(currentProduct!),
                    ),
                    ShareProductButton(productId: widget.productId),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'product-${currentProduct.id}',
                      child: Image.network(
                        currentProduct.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    transform: Matrix4.translationValues(0.0, -32.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  currentProduct.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontSize: 28,
                                        height: 1.2,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '\$${currentProduct.price.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontSize: 24,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Description',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentProduct.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.6,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Select Color',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          ColorSelector(
                            colors: currentProduct.colors,
                            selectedColor: _selectedColor!,
                            onColorSelected: (color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Select Size',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          SizeSelector(
                            sizes: currentProduct.sizes,
                            selectedSize: _selectedSize!,
                            onSizeSelected: (size) {
                              setState(() {
                                _selectedSize = size;
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            text: 'Add to Cart',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${currentProduct!.name} added to cart'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: AppTheme.primary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
