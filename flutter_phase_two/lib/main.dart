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

// 1. A custom blue-print structure for our habits
class HabitItem {
  String name;
  bool isDone;

  HabitItem({required this.name, this.isDone = false});
}

class _TodoListScreenState extends State<TodoListScreen> {
  // 2. Updated our memory list to use our new HabitItem blueprint!
  List<HabitItem> habits = [
    HabitItem(name: 'Buy groceries'),
    HabitItem(name: 'Learn Flutter'),
    HabitItem(name: 'Go for a run'),
  ];
  final TextEditingController _textController = TextEditingController();

  void _addNewHabit() {
    if (_textController.text.isEmpty) return;

    setState(() {
      habits.add(HabitItem(name: _textController.text));
      _textController.clear();
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new habit...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addNewHabit,
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
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      habits[index].name,
                      // 3. Strikethrough style if the habit is checked off!
                      style: TextStyle(
                        decoration: habits[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: habits[index].isDone
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    leading: Icon(
                      // 4. Change icon depending on state
                      habits[index].isDone
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.blueAccent,
                    ),
                    // 5. This functions triggers when a user taps anywhere on the row!
                    onTap: () {
                      setState(() {
                        // Toggle the true/false value!
                        habits[index].isDone = !habits[index].isDone;
                      });
                    },
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
