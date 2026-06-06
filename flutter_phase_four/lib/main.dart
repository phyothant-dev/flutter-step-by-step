import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const RecipeHomeScreen(),
    );
  }
}

// 1. Create a custom blueprint to model real recipe datasets
class Recipe {
  final String title;
  final String duration;
  final List<String> ingredients;
  final List<String> steps;

  const Recipe({
    required this.title,
    required this.duration,
    required this.ingredients,
    required this.steps,
  });
}

// --- SCREEN 1: THE HOME LIST VIEW ---
class RecipeHomeScreen extends StatelessWidget {
  const RecipeHomeScreen({super.key});

  // 2. An array holding structural recipe data objects
  final List<Recipe> originalRecipes = const [
    Recipe(
      title: 'Spaghetti Carbonara',
      duration: '25 mins',
      ingredients: [
        '200g Spaghetti',
        '100g Guanciale/Pancetta',
        '2 Whole Eggs',
        '50g Pecorino Cheese',
      ],
      steps: [
        'Boil pasta in salted water.',
        'Crisp the pork in a dry pan.',
        'Whisk eggs and cheese together.',
        'Combine everything off the heat.',
      ],
    ),
    Recipe(
      title: 'Chocolate Chip Cookies',
      duration: '45 mins',
      ingredients: [
        '200g Flour',
        '150g Butter',
        '100g Sugar',
        '150g Chocolate Chips',
      ],
      steps: [
        'Cream butter and sugar together.',
        'Mix in flour gently.',
        'Fold in chocolate chips.',
        'Bake at 180°C for 12 minutes.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grandma\'s Cookbook'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: originalRecipes.length,
        itemBuilder: (context, index) {
          final recipe = originalRecipes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: ListTile(
              leading: const Icon(
                Icons.restaurant_menu,
                color: Colors.redAccent,
              ),
              title: Text(
                recipe.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('⏱️ Cooking Time: ${recipe.duration}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // 3. Passing the ENTIRE recipe data object inside our route push argument!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
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

// --- SCREEN 2: THE RESTRUCTURED DETAIL PAGE ---
class RecipeDetailScreen extends StatelessWidget {
  // Catching the complete recipe object here
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(recipe.duration),
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            // Displaying mapped widgets dynamically inside a column layout frame
            ...recipe.ingredients.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text('• $item', style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipe.steps.length,
                itemBuilder: (context, stepIndex) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      maxRadius: 12,
                      backgroundColor: Colors.redAccent,
                      child: Text(
                        '${stepIndex + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      recipe.steps[stepIndex],
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
