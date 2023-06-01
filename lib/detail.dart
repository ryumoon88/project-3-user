import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_3_tablet/models/product_category.dart';
import 'package:project_3_tablet/widgets/color_button.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = getProductData();
  }

  Future<Product?> getProductData() async {
    var response = await http.get(
        Uri.parse('http://localhost:3000/api/v1/products/${widget.productId}'));
    var responseJson = jsonDecode(response.body);
    debugPrint(responseJson.toString());
    return Product.fromJson(responseJson['data']['product']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
      ),
      body: FutureBuilder(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Product product = snapshot.data!;
          return SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CarouselSlider.builder(
                      itemCount: 5,
                      itemBuilder: (context, index, realIndex) {
                        return CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 3 / 2,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: false,
                        viewportFraction: 0.8,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Price: \Rp.${product.basePrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Stock: ${product.categoryId}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Color",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ColorButton();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Lokasi Barang ",
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(product.description),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
