import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_3_tablet/models/product.dart';
import 'package:project_3_tablet/models/product_category.dart';
import 'package:project_3_tablet/widgets/balloon_button.dart';
import 'package:project_3_tablet/widgets/product_card.dart';
import 'package:http/http.dart' as http;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = List.empty(growable: true);
  List<ProductCategory> productCategories = List.empty(growable: true);

  int? currentCategory;

  @override
  void initState() {
    super.initState();
    getProductCategories();
    getProducts();
  }

  void getProducts({int categoryIndex = 0}) async {
    String url = "http://localhost:3000/api/v1/products";

    if (categoryIndex != 0) {
      var category = productCategories[categoryIndex].id;
      url += "?categoryId=$category";
    }
    var response = await http.get(Uri.parse(url));

    var responseJson = jsonDecode(response.body);

    if (responseJson['status'] == 'success') {
      setState(() {
        products.clear();
        for (var el in responseJson['data']['products']) {
          products.add(Product.fromJson(el));
        }
        currentCategory = categoryIndex;
      });
    }
  }

  void getProductCategories() async {
    var response = await http
        .get(Uri.parse("http://localhost:3000/api/v1/product-categories"));
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (responseJson['status'] == 'success') {
      setState(() {
        productCategories.add(ProductCategory(id: 0, name: 'All'));
        for (var el in responseJson['data']) {
          productCategories.add(ProductCategory.fromJson(el));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                scrollDirection: Axis.horizontal,
                itemCount: productCategories.length,
                itemBuilder: (context, index) {
                  return CategoryButton(
                    category: productCategories[index],
                    index: index,
                    callback: () => index == 0
                        ? getProducts()
                        : getProducts(categoryIndex: index),
                    active: currentCategory == index,
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: (2 / 3),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
