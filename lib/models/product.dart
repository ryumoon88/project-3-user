import 'package:project_3_tablet/models/media.dart';
import 'package:project_3_tablet/models/product_category.dart';
import 'package:project_3_tablet/models/product_variant.dart';

class Product {
  int id;
  String name;
  int categoryId;
  String description;
  int basePrice;
  int sellPrice;
  double discount;
  DateTime createdAt;
  DateTime updatedAt;

  ProductCategory? category;
  List<ProductVariant>? variants;

  int? get stocks {
    return variants!
        .map((e) => e.stock)
        .toList()
        .reduce((value, element) => value + element);
  }

  List<Media>? get images {
    return variants!.expand((e) => e.medias!.toList()).toList();
  }

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.basePrice,
    required this.sellPrice,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        categoryId: json['categoryId'] as int,
        description: json['description'] as String,
        basePrice: json['basePrice'] as int,
        sellPrice: json['sellPrice'] as int,
        discount: double.parse(json['discount'].toString()),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        category: json['category'] == null
            ? null
            : ProductCategory.fromJson(json['category']),
        variants: json['variants'] == null
            ? []
            : (json['variants'] as List<dynamic>)
                .map((variantJson) => ProductVariant.fromJson(variantJson))
                .toList(),
      );
}
