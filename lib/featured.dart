import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_3_tablet/models/product.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class FeaturedProductsPage extends StatefulWidget {
  const FeaturedProductsPage({super.key});

  @override
  State<FeaturedProductsPage> createState() => _FeaturedProductsPageState();
}

class _FeaturedProductsPageState extends State<FeaturedProductsPage> {
  List<Product> products = List.empty(growable: true);

  int? currentCategory;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  void getProducts({int categoryIndex = 0, int limit = 18}) async {
    String url = "http://localhost:3000/api/v1/products";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Featured Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: (2 / 3),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length < 18 ? products.length : 18,
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

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ProductScreenArguments args = ProductScreenArguments(product: product);
        // GoRouter.of(context).go("/products/${product.id}");
        Navigator.pushNamed(context, '/detail', arguments: product.id);
      },
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: (4 / 3),
              child: CachedNetworkImage(
                imageUrl: product.images!.first.fileName,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, progress) =>
                    const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp. ${product.basePrice}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Stock: ${product.categoryId}",
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
