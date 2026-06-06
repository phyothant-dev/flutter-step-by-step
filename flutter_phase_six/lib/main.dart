import 'dart:convert'; // Essential for de-serializing/serializing JSON strings!
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PersistentCartProvider(),
      child: const ECommerceApp(),
    ),
  );
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductCatalogScreen(),
    );
  }
}

// --- DATA BLUEPRINT ---
class Product {
  final String id;
  final String title;
  final double price;

  const Product({required this.id, required this.title, required this.price});

  // Convert a Product object into a Map structure to prepare it for JSON string conversion
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'price': price};
  }

  // Reconstruction constructor to safely rebuild data profiles extracted from disk records
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }
}

// --- UPGRADED STATE SYSTEM WITH DISK STORAGE INTEGRATION ---
class PersistentCartProvider extends ChangeNotifier {
  final List<Product> _items = [];
  List<Product> get items => _items;

  // Unique local database storage key identifier token string
  static const String _storageKey = 'cached_shopping_cart_items';

  // Constructor naturally fires a background disk audit initialization cycle on boot
  PersistentCartProvider() {
    _loadItemsFromDisk();
  }

  // 1. ASYNCHRONOUS BACKGROUND LAYER: Read data records back from the storage chip
  Future<void> _loadItemsFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? serializedData = prefs.getString(_storageKey);

      if (serializedData != null) {
        // Parse raw string back into a standard iterable collection list array structure
        final List<dynamic> decodedList = jsonDecode(serializedData);

        _items.clear();
        for (var element in decodedList) {
          _items.add(Product.fromMap(element as Map<String, dynamic>));
        }
        notifyListeners(); // Refresh UI layouts with items recovered from physical disk!
      }
    } catch (e) {
      debugPrint('Disk Retrieval Error: $e');
    }
  }

  // 2. ASYNCHRONOUS BACKGROUND LAYER: Write string records onto physical storage
  //  FIXED
  Future<void> _saveItemsToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Map item schemas into generic raw data structures and compress into a clean String format
      final List<Map<String, dynamic>> productMaps = _items
          .map((item) => item.toMap())
          .toList();
      final String encryptedString = jsonEncode(productMaps);

      await prefs.setString(_storageKey, encryptedString);
    } catch (e) {
      debugPrint('Disk Save Failure: $e');
    }
  }

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
    _saveItemsToDisk(); // Save to disk in the background after updating local memory state!
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
    _saveItemsToDisk(); // Update disk layout synchronously!
  }
}

// --- SCREEN 1: PRODUCT CATALOG VIEWS ---
class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({super.key});

  final List<Product> catalogProducts = const [
    Product(id: 'p1', title: 'MacBook Pro', price: 1999.99),
    Product(id: 'p2', title: 'iPhone 15', price: 999.99),
    Product(id: 'p3', title: 'AirPods Max', price: 549.99),
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<PersistentCartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent Store'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Consumer<PersistentCartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.items.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cart.items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: catalogProducts.length,
        itemBuilder: (context, index) {
          final product = catalogProducts[index];
          final isInCart = cartProvider.items.any(
            (item) => item.id == product.id,
          );

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: ListTile(
              title: Text(
                product.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () =>
                    !isInCart ? cartProvider.addToCart(product) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? Colors.grey : Colors.teal,
                ),
                child: Text(
                  isInCart ? 'Saved' : 'Add to Cart',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- SCREEN 2: CART BACKEND DISPLAY VIEW ---
class CartDetailsScreen extends StatelessWidget {
  const CartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<PersistentCartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Persistent Cart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text('Your cart is completely empty.'))
          : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  leading: const Icon(Icons.bookmark_added, color: Colors.teal),
                  title: Text(item.title),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => cartProvider.removeFromCart(item),
                  ),
                );
              },
            ),
    );
  }
}
