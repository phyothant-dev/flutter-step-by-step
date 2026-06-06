import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 1. Import the internet package
import 'dart:convert'; // 2. Import a helper to decode JSON text

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
  // Our local state variables to hold the server's response
  String bitcoinPrice = 'Loading...';
  bool isLoading = true;

  // 3. This is an ASYNCHRONOUS function. It runs in the background.
  Future<void> fetchBitcoinPrice() async {
    try {
      // The web address that returns raw text data about Bitcoin
      final url = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd',
      );

      // 'await' tells the app: "Wait here patiently until the server responds, but don't freeze the UI!"
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successfully got data! Decode the text string into a readable map
        final data = jsonDecode(response.body);

        // Update our local state with the extracted price
        setState(() {
          bitcoinPrice = '\$' + data['bitcoin']['usd'].toString();
          isLoading = false;
        });
      } else {
        setState(() {
          bitcoinPrice = 'Error loading price';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        bitcoinPrice = 'No Internet Connection';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 4. This automatically triggers our internet request the exact moment the app opens
    fetchBitcoinPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Crypto Tracker'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.orangeAccent,
              ) // Show a spinning loading wheel
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.currency_bitcoin,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Bitcoin (BTC) Price:',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bitcoinPrice,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // A button to manually refresh the price
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      fetchBitcoinPrice();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Price'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
