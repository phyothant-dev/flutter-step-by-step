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

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // 1. This is our list of habits (our App Memory/State)
  List<String> tasks = ['Buy groceries', 'Learn Flutter', 'Go for a run'];

  // 2. This is the controller that captures what the user types inside the box
  final TextEditingController _textController = TextEditingController();

  // 3. This function adds a new item to our list safely
  void _addNewTask() {
    // If the input box is empty, don't do anything!
    if (_textController.text.isEmpty) return;

    // This is the magic function! It tells Flutter to refresh the screen with new data.
    setState(() {
      tasks.add(_textController.text); // Add what the user typed to our list
      _textController
          .clear(); // Clear out the input field so it's fresh for next time
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habit Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // 4. This is the input box row layout
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        _textController, // Attaching our controller here
                    decoration: const InputDecoration(
                      hintText: 'Enter a new habit...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // The add button right next to the text box
                ElevatedButton(
                  onPressed: _addNewTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // 5. This displays our dynamic list
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
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
          ),
        ],
      ),
    );
  }
}
