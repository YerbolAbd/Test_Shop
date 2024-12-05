import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_shop/screens/product_detail_screen.dart';
import 'add_product_screen.dart';
import 'package:test_shop/models/product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Box<Product> productBox;
  List<Product> filteredProducts = [];
  String searchQuery = '';
  String sortOrder = 'price';
  bool _isAscendingPrice = true;
  bool _isAscendingQuantity = true;
  bool _isSearching = false;

  void _onSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('products');
    filteredProducts = productBox.values.toList();
  }

  void _refreshProductList() {
    setState(() {
      filteredProducts = productBox.values.toList();
    });
  }

  void _deleteProduct(int index) async {
    await productBox.deleteAt(index);
  }

  void _sortProducts(String sortBy) {
    setState(() {
      if (sortBy == 'price') {
        _isAscendingPrice = !_isAscendingPrice;
        filteredProducts.sort((a, b) => _isAscendingPrice
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price));
      } else if (sortBy == 'quantity') {
        _isAscendingQuantity = !_isAscendingQuantity;
        filteredProducts.sort((a, b) => _isAscendingQuantity
            ? a.quantity.compareTo(b.quantity)
            : b.quantity.compareTo(a.quantity));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (sortBy) {
              setState(() {
                sortOrder = sortBy;
                _sortProducts(sortBy);
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'price', child: Text('Sort by Price')),
              const PopupMenuItem(value: 'quantity', child: Text('Sort by Quantity')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _onSearch();
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Dismissible(
              key: Key(product.id.toString()),  // Unique key for each product
              direction: DismissDirection.endToStart,  // Swipe to delete
              onDismissed: (direction) {
                _deleteProduct(index);  // Delete the product
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} deleted')),
                );
              },
          child:  ListTile(
            title: Text(product.name),
            subtitle: Text('${product.category} - \$${product.price}'),
            trailing: Text('Qty: ${product.quantity}'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)
                  ));
            },
          ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen(
              onProductAdded: _refreshProductList,
            )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ProductListScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ProductListScreen();
  }
}
