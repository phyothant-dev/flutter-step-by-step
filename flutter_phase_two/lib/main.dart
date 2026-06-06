import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TodoListScreen());
  }
}

// 1. This is our Stateful Widget! It monitors changes.
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// 2. This is the "State" class. Our actual UI and data live here.
class _TodoListScreenState extends State<TodoListScreen> {
  // This is our app's memory (State). A list of tasks!
  List<String> tasks = [
    'Buy groceries',
    'Learn Flutter',
    'Go for a run',
    'Read a book',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habit Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: tasks.length, // Tells Flutter how many items are in our list
        itemBuilder: (context, index) {
          // This function runs automatically for every item in our list
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(tasks[index]),
              leading: const Icon(
                Icons.check_box_outline_blank,
                color: Colors.blueAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}
