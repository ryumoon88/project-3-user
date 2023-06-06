import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:project_3_tablet/models/media.dart';
import 'package:project_3_tablet/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedVariant = -1;

  bool _isLoading = true;

  Product? product;
  List<Media>? showedImages;
  int? showedStock;

  @override
  void initState() {
    super.initState();
    getProductData();
  }

  void setSelectedVariant(int index) {
    setState(() {
      if (selectedVariant == index) {
        selectedVariant = -1;
        showedImages = product!.images;
        showedStock = product!.stocks;
        return;
      }
      selectedVariant = index;
      showedStock = product!.variants![index].stock;
      showedImages = product!.variants![index].medias;
    });
  }

  getProductData() async {
    var response = await http.get(
        Uri.parse('http://192.168.1.15:3000/api/v1/products/${widget.productId}'));
    var responseJson = jsonDecode(response.body);
    if (responseJson['status'] == 'success') {
      setState(() {
        product = Product.fromJson(responseJson['data']['product']);
        showedImages = product!.images;
        showedStock = product!.stocks;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CarouselSlider.builder(
                    itemCount: showedImages!.length,
                    itemBuilder: (context, index, realIndex) {
                      return CachedNetworkImage(
                        imageUrl: showedImages![index].path != ""
                            ? "http://localhost:3000/api/uploads/${showedImages![index].fileName}"
                            : showedImages![index].fileName,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      aspectRatio: (4 / 3),
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product!.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Stock: ${showedStock}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Rp. ${product!.basePrice}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Color",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product!.variants!.length,
                            itemBuilder: (context, index) {
                              var HexColor;
                              return InkWell(
                                borderRadius: BorderRadius.circular(40),
                                onTap: () => setSelectedVariant(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedVariant == index
                                            ? Colors.blue
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                      shape: BoxShape.circle,
                                      color: HexColor.fromHex(
                                          product!.variants![index].color),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Lokasi Barang",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(product!.description),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
