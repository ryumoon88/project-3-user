class Product {
  int id;
  String name;
  int categoryId;
  String description;
  int basePrice;
  int sellPrice;
  double discount;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.basePrice,
    required this.sellPrice,
    required this.discount,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        categoryId: json['categoryId'] as int,
        description: json['description'] as String,
        basePrice: json['basePrice'] as int,
        sellPrice: json['sellPrice'] as int,
        discount: json['discount'] as double,
        imageUrl: json['imageUrl'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
