import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Import the global state manager

void main() {
  runApp(
    // 2. Wrap the entire application inside a ChangeNotifierProvider
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductCatalogScreen(),
    );
  }
}

// --- THE DATA WAREHOUSE (STATE PROVIDER) ---
// 3. Extending ChangeNotifier lets this class broadcast updates to the UI automatically
class CartProvider extends ChangeNotifier {
  final List<String> _cartItems = [];

  List<String> get cartItems => _cartItems;

  void addToCart(String productName) {
    _cartItems.add(productName);
    // 4. Crucial command! Tells every listening widget to repaint itself with the new data
    notifyListeners();
  }

  void removeFromCart(String productName) {
    _cartItems.remove(productName);
    notifyListeners();
  }
}

// --- SCREEN 1: PRODUCT CATALOG ---
class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({super.key});

  final List<String> products = const [
    'MacBook Pro',
    'iPhone 15',
    'AirPods Max',
    'iPad Air',
  ];

  @override
  Widget build(BuildContext context) {
    // 5. Read from our warehouse to display the live count in the badge
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gadget Store'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartDetailsScreen(),
                    ),
                  );
                },
              ),
              if (cartProvider.cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartProvider.cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isInCart = cartProvider.cartItems.contains(product);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: ListTile(
              title: Text(
                product,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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

// --- SCREEN 2: CART DETAILS SCREEN ---
class CartDetailsScreen extends StatelessWidget {
  const CartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 6. Connect to the same warehouse from an entirely separate screen!
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping Cart'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text('Your cart is completely empty.'))
          : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];
                return ListTile(
                  leading: const Icon(Icons.check, color: Colors.green),
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      cartProvider.removeFromCart(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
