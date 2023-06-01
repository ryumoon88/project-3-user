import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'About Our Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'We are a leading e-commerce store that provides customers with a wide range of products at affordable prices. Our store is committed to providing an exceptional shopping experience for all our customers.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 32.0),
            Text(
              'Connect With Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Stay connected with us on social media to get the latest updates on our products, promotions, and deals. Follow us on:',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.facebook),
                  iconSize: 50.0,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.telegram),
                  iconSize: 50.0,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.telegram),
                  iconSize: 50.0,
                  color: Colors.pinkAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}