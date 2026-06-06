import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. MODERN RIVERPOD 3 NOTIFIER & PROVIDER DEFINITION
// We extend Notifier to manage an internal state variable type of 'int'
class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0; // Set your initial state value here
  }

  void increment() {
    state++; // 'state' is natively exposed inside Notifier classes
  }

  void decrement() {
    state--;
  }
}

// Instantiate the NotifierProvider globally
final counterProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});

void main() {
  runApp(
    // Riverpod requires wrapping your root widget tree inside a ProviderScope
    const ProviderScope(child: RiverpodStateApp()),
  );
}

class RiverpodStateApp extends StatelessWidget {
  const RiverpodStateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const RiverpodCounterScreen(),
    );
  }
}

// 2. UI PRESENTATION LAYER (Extends ConsumerWidget to safely access ref)
class RiverpodCounterScreen extends ConsumerWidget {
  const RiverpodCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch() listens to changes and triggers a rebuild when the counter updates
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod 3.x Notifier State'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You pressed the action button this many times:'),
            Text(
              '$count',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Access the class methods via the notifier parameter handle
              ref.read(counterProvider.notifier).decrement();
            },
            heroTag: 'decrement_btn',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () {
              ref.read(counterProvider.notifier).increment();
            },
            heroTag: 'increment_btn',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
