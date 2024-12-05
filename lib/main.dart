import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/product.dart';
import 'screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  var box = await Hive.openBox<Product>('products');

  if (box.isEmpty) {
    final defaultProducts = [
      Product(id: 1, name: "Яблоки", category: "Еда", price: 300, quantity: 50, description: "Свежие яблоки из сада.", image: "path/to/image.jpg", isFavorite: false),
      Product(id: 2, name: "Молоко", category: "Напитки", price: 200, quantity: 30, description: "Натуральное молоко от фермеров.", image: "path/to/image2.jpg", isFavorite: true),
    ];

    for (var product in defaultProducts) {
      await box.add(product);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}
