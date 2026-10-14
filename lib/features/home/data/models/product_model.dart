import '../../domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.images,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    List<String> parsedImages = [];
    if (rawImages is List) {
      for (var img in rawImages) {
        if (img != null) {
          final cleaned = _cleanUrl(img.toString());
          if (cleaned.isNotEmpty) {
            parsedImages.add(cleaned);
          }
        }
      }
    }
    if (parsedImages.isEmpty) {
      parsedImages = ['https://picsum.photos/seed/${json['id'] ?? 1}/300/300'];
    }

    return ProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'Product',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description']?.toString() ?? '',
      images: parsedImages,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  static String _cleanUrl(String url) {
    String cleaned = url.replaceAll(RegExp(r'[\[\]\\"]'), '').trim();
    if (!cleaned.startsWith('http')) {
      return 'https://picsum.photos/300/300';
    }
    return cleaned;
  }
}
