import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';
import 'category_entity.dart';

class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final CategoryEntity? category;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
  });

  String get name => title;
  String get imageUrl =>
      images.isNotEmpty ? images.first : 'https://picsum.photos/300/300';
  List<Color> get colors => const [Colors.white, Colors.black, Colors.blue];
  List<String> get sizes => const ['S', 'M', 'L', 'XL'];

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
