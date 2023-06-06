import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_3_tablet/models/product.dart';
import 'package:project_3_tablet/models/product_category.dart';
import 'package:project_3_tablet/widgets/balloon_button.dart';
import 'package:project_3_tablet/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<ProductCategory> productCategories = [];
  int? currentCategory;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    getProductCategories();
    getProducts();
  }

  Future<void> getProducts({int categoryIndex = 0}) async {
    String url = "http://localhost:3000/api/v1/products";

    if (categoryIndex != 0) {
      var category = productCategories[categoryIndex].id;
      url += "?categoryId=$category";
    }
    var response = await http.get(Uri.parse(url));

    var responseJson = jsonDecode(response.body);

    if (responseJson['status'] == 'success') {
      setState(() {
        products = [];
        for (var el in responseJson['data']['products']) {
          products.add(Product.fromJson(el));
        }
        currentCategory = categoryIndex;
        filterProducts();
      });
    }
  }

  Future<void> getProductCategories() async {
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

  void filterProducts() {
    if (searchQuery.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  void shareProduct(Product product) {
    // Implement share functionality here using product data
    String productName = product.name;
    String productDescription = product.description;

    // Example: Share product name and description
    String shareText =
        'Check out this product: $productName - $productDescription';
    // Implement your own share logic here
    // ...
  }

  bool _searchBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('TOKO AMRIL'),
            Spacer(),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width:
                  _searchBarVisible ? MediaQuery.of(context).size.width / 2 : 0,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    filterProducts();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            IconButton(
              icon: Icon(_searchBarVisible ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _searchBarVisible = !_searchBarVisible;
                  if (!_searchBarVisible) {
                    searchQuery = '';
                    filterProducts();
                  }
                });
              },
            ),
          ],
        ),
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
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: filteredProducts[index],
                    onShare: () => shareProduct(filteredProducts[index]),
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
