import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CryptoPriceScreen());
  }
}

class CryptoPriceScreen extends StatefulWidget {
  const CryptoPriceScreen({super.key});

  @override
  State<CryptoPriceScreen> createState() => _CryptoPriceScreenState();
}

class _CryptoPriceScreenState extends State<CryptoPriceScreen> {
  // 1. Instead of a single string, we use a Map to keep multiple coin values!
  Map<String, dynamic> coinPrices = {};
  bool isLoading = true;

  Future<void> fetchPrices() async {
    try {
      // We modified the URL address to ask for bitcoin, ethereum, and litecoin all at once!
      final url = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin&vs_currencies=usd',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          coinPrices = data; // Store the whole nested JSON map into our state
          isLoading = false;
        });
      } else {
        showSnackbarError('Server returned an error');
      }
    } catch (e) {
      showSnackbarError('No Internet Connection');
    }
  }

  void showSnackbarError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    fetchPrices();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Extract keys so our ListView builder knows how to reference them by index
    List<String> coinKeys = coinPrices.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Crypto Tracker'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchPrices();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            )
          : coinKeys.isEmpty
          ? const Center(child: Text('No data found.'))
          : ListView.builder(
              itemCount: coinKeys.length,
              itemBuilder: (context, index) {
                String coinName = coinKeys[index];
                // Accessing nested maps safely: data['bitcoin']['usd']
                double price = coinPrices[coinName]['usd'].toDouble();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      child: Icon(
                        coinName == 'bitcoin'
                            ? Icons.currency_bitcoin
                            : Icons.monetization_on,
                        color: Colors.orange,
                      ),
                    ),
                    // capitalize the first letter of the coin key for the UI display
                    title: Text(
                      coinName.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
