import 'package:flutter/material.dart';
import '../../../core/dummy_data.dart';
import 'category_model.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
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

  // Compatibility getters with the existing Product class:
  String get name => title;
  String get imageUrl =>
      images.isNotEmpty ? images.first : 'https://picsum.photos/300/300';
  List<Color> get colors => [Colors.white, Colors.black, Colors.blue];
  List<String> get sizes => ['S', 'M', 'L', 'XL'];

  Product toProduct() => Product(
        id: id.toString(),
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        colors: colors,
        sizes: sizes,
      );
}
