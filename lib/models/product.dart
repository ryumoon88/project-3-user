class ProductCategory {
  int id;
  String name;

  ProductCategory({
    required this.id,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json['id'] as int,
        name: json['name'] as String,
      );
}