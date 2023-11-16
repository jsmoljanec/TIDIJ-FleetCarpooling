import 'package:firebase_core/firebase_core.dart';
import 'package:fleetcarpooling/pages/loginForm.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyAiAzExpBKwIfaYhntOua3f7qNMJ5ecdA0',
        appId: '1:956285703635:android:1faaaa1cfb6be0d4d58b26',
        messagingSenderId: '956285703635',
        projectId: 'fleetcarpooling-cd243',
        databaseURL:
            'https://fleetcarpooling-cd243-default-rtdb.europe-west1.firebasedatabase.app/'),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextEditingController myController = TextEditingController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginForm());
  }
}
