import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BusinessCardScreen());
  }
}

class BusinessCardScreen extends StatelessWidget {
  const BusinessCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Dark sleek background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 1. Profile Image Circle
              const CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.white,
                // Replace with your own image URL later
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),

              // 2. Your Name
              const Text(
                'Phyo thant',
                style: TextStyle(
                  fontFamily:
                      'Pacifico', // Must match the family name in pubspec.yaml
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 3. Your Title
              Text(
                'FLUTTER DEVELOPER',
                style: TextStyle(
                  fontFamily:
                      'SourceSans', // Must match the family name in pubspec.yaml
                  fontSize: 20.0,
                  color: Colors.blueGrey[200],
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 4. A Sleek Divider Line
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(color: Colors.blueGrey.shade100),
              ),

              // 5. Contact Info Card: Phone
              Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Colors.blueGrey),
                  title: Text(
                    '+1 234 567 8901',
                    style: TextStyle(
                      color: Colors.blueGrey.shade900,
                      fontSize: 20.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              // 6. Contact Info Card: Email
              Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.blueGrey),
                  title: Text(
                    'alex.dev@email.com',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey.shade900,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
