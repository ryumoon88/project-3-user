import 'package:project_3_tablet/models/media.dart';

class ProductVariant {
  int id;
  int productId;
  String color;
  int stock;
  DateTime createdAt;
  DateTime updatedAt;

  List<Media>? medias;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.color,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    this.medias,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json['id'] as int,
        productId: json['productId'],
        color: json['color'],
        stock: json['stock'],
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        medias: json['medias'] == null
            ? []
            : (json['medias'] as List<dynamic>)
                .map((mediasJson) => Media.fromJson(mediasJson))
                .toList(),
      );
}
