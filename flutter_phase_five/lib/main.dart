import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const ECommerceApp(),
    ),
  );
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductCatalogScreen(),
    );
  }
}

// 1. Structural blueprint representing specialized product data objects
class Product {
  final String id;
  final String title;
  final double price;

  const Product({required this.id, required this.title, required this.price});
}

// --- THE UPGRADED GLOBAL STATE WAREHOUSE ---
class CartProvider extends ChangeNotifier {
  // Store full Product records instead of plain text Strings
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners(); // Broadcasts recalculation requirements immediately
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }
}

// --- SCREEN 1: OPTIMIZED PRODUCT CATALOG SCREEN ---
class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({super.key});

  final List<Product> catalogProducts = const [
    Product(id: 'p1', title: 'MacBook Pro', price: 1999.99),
    Product(id: 'p2', title: 'iPhone 15', price: 999.99),
    Product(id: 'p3', title: 'AirPods Max', price: 549.99),
    Product(id: 'p4', title: 'iPad Air', price: 599.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gadget Store'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // 2. Using Consumer here so ONLY the shopping bag icon area rebuilds on cart adjustments
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag),
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

          // 3. Listen to state changes to see if this specific element card is in the cart
          final cartProvider = Provider.of<CartProvider>(context);
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
                onPressed: () {
                  if (!isInCart) {
                    cartProvider.addToCart(product);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? Colors.grey : Colors.blueAccent,
                ),
                child: Text(
                  isInCart ? 'Added' : 'Add to Cart',
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

// --- SCREEN 2: THE DETAILED AGGREGATED CART SCREEN ---
class CartDetailsScreen extends StatelessWidget {
  const CartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. Hook into our provider store to compile structural items and total cost mathematical evaluations
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping Cart'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text('Your cart is completely empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(item.title),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            cartProvider.removeFromCart(item);
                          },
                        ),
                      );
                    },
                  ),
                ),
                // 5. Total Price aggregation calculation display bottom container panel card layout boundaries
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
