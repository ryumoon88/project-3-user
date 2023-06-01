import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_3_tablet/about.dart';
import 'package:project_3_tablet/categories.dart';
import 'package:project_3_tablet/detail.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_3_tablet/models/product_category.dart';
import 'package:project_3_tablet/featured.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Amril',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => HomePage(),
          );
        }
        if (settings.name == '/about') {
          return MaterialPageRoute(
            builder: (context) => AboutPage(),
          );
        }
        if (settings.name == '/categories') {
          return MaterialPageRoute(
            builder: (context) => ProductsScreen(),
          );
        }
        if (settings.name == '/featured') {
          return MaterialPageRoute(
            builder: (context) => FeaturedProductsPage(),
          );
        }
        if (settings.name == '/detail') {
          return MaterialPageRoute(
            builder: (context) {
              debugPrint(settings.arguments.toString());
              return ProductDetailScreen(
                productId: settings.arguments as int,
              );
            },
          );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  int? currentCategory;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts({int categoryIndex = 0}) async {
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
                });
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue[150],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text(
                      'Product',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/categories');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text(
                      'Featured',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/featured');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1523413651479-597eb2da0ad6'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Welcome to our E-commerce App',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/featured');
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return AspectRatio(
                          aspectRatio: (2 / 3),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/detail',
                                  arguments: products[index].id);
                            },
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                                      imageUrl: products[index].imageUrl,
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            products[index].name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Rp. ${products[index].basePrice}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            "Stock: ${products[index].categoryId}",
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
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/categories');
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return AspectRatio(
                          aspectRatio: (2 / 3),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/detail',
                                  arguments: products[index].id);
                            },
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                                      imageUrl: products[index].imageUrl,
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            products[index].name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Rp. ${products[index].basePrice}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            "Stock: ${products[index].categoryId}",
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
