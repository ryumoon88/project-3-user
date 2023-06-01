// import 'package:flutter/material.dart';

// class SeeAllScreen extends StatelessWidget {
//   final List<Product> products;

//   SeeAllScreen({required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('See All'),
//       ),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Image.network(products[index].imageUrl),
//             title: Text(products[index].name),
//             subtitle: Text(products[index].description),
//             trailing: Text('\$${products[index].price.toString()}'),
//             onTap: () {
//               // Tambahkan kode untuk menavigasi ke halaman detail produk
//             },
//           );
//         },
//       ),
//     );
//   }
// }
