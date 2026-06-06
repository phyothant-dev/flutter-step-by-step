import 'package:flutter/material.dart';

void main() {
  runApp(const AdvancedNavigationApp());
}

class AdvancedNavigationApp extends StatelessWidget {
  const AdvancedNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainNavigationShell(),
    );
  }
}

// --- LEVEL 1: THE PERSISTENT GLOBAL SHELL ---
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // Distinct master branches available across our bottom shortcut menu layout
  final List<Widget> _tabViews = [
    const NestedHomeTabBranch(), // This tab contains its own inner sub-navigation tree!
    const SettingsTabBranch(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves state across tabs, preventing screens from resetting when switching
      body: IndexedStack(index: _currentIndex, children: _tabViews),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home Branch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// --- LEVEL 2: THE NESTED ROUTING BRANCH (HOME) ---
class NestedHomeTabBranch extends StatelessWidget {
  const NestedHomeTabBranch({super.key});

  // Unique key used to control the state of the inner navigation pipeline explicitly
  static final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Wrapping this view branch in a dedicated Navigator component sets up its own inner stack
    return Navigator(
      key: homeNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const HomeLandingScreen();
            break;
          case '/details':
            builder = (BuildContext context) => const HomeNestedDetailsScreen();
            break;
          default:
            throw Exception(
              'Invalid route handle identifier: ${settings.name}',
            );
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

// --- SUB-SCREEN A: HOME LANDING SCREEN ---
class HomeLandingScreen extends StatelessWidget {
  const HomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Master Layer'),
        backgroundColor: Colors.teal.shade100,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers, size: 70, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Welcome to the Home Root Tab',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pushes a view onto the internal sub-navigator stack.
                // The outer shell and bottom bar stay fixed and visible!
                Navigator.pushNamed(context, '/details');
              },
              child: const Text('Drill Down into Nested Details'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SUB-SCREEN B: NESTED CHILD DETAILS SCREEN ---
class HomeNestedDetailsScreen extends StatelessWidget {
  const HomeNestedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Child Viewport'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_tree_outlined,
              size: 60,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Look closely! You drilled deep inside this branch.\nThe main bottom navigation bar remains accessible below!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back Up One Level'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SUB-SCREEN C:SETTINGS BRANCH ---
class SettingsTabBranch extends StatelessWidget {
  const SettingsTabBranch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Configurations'),
        backgroundColor: Colors.grey[200],
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 70, color: Colors.blueGrey),
            SizedBox(height: 12),
            Text(
              'Independent Tab Context Area',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
