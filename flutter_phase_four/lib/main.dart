import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RecipeHomeScreen());
  }
}

// --- SCREEN 1: THE HOME SCREEN ---
class RecipeHomeScreen extends StatelessWidget {
  const RecipeHomeScreen({super.key});

  // Simple hardcoded list of recipes for our beginner layout
  final List<String> recipes = const [
    'Spaghetti Carbonara',
    'Chocolate Chip Cookies',
    'Chicken Stir Fry',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grandma\'s Cookbook'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(recipes[index], style: const TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // 1. The MAGIC tool to move to a new screen (Pushing a card onto the stack)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetailScreen(recipeName: recipes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// --- SCREEN 2: THE DETAIL SCREEN ---
class RecipeDetailScreen extends StatelessWidget {
  // 2. This variable acts like a mailbox to catch data passed from the first screen
  final String recipeName;

  const RecipeDetailScreen({super.key, required this.recipeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipeName,
        ), // Displays the specific recipe title passed over!
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to cook $recipeName:',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Prep your fresh ingredients carefully.\n'
              '2. Combine them inside a heated pan.\n'
              '3. Cook thoroughly and serve warm!',
              style: TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 3. Popping this card off the stack manually to go back home
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  'Back to Recipes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
