import 'package:flutter/material.dart';
import 'package:test_shop/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${product.name}', style: TextStyle(fontSize: 22)),
            Text('Category: ${product.category}', style: TextStyle(fontSize: 18)),
            Text('Price: \$${product.price}', style: TextStyle(fontSize: 18)),
            Text('Quantity: ${product.quantity}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
