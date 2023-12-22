import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:fleetcarpooling/pages/login_form.dart';
import 'package:fleetcarpooling/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAiAzExpBKwIfaYhntOua3f7qNMJ5ecdA0',
      appId: '1:956285703635:android:1faaaa1cfb6be0d4d58b26',
      messagingSenderId: '956285703635',
      projectId: 'fleetcarpooling-cd243',
      storageBucket: 'gs://fleetcarpooling-cd243.appspot.com',
      databaseURL:
          'https://fleetcarpooling-cd243-default-rtdb.europe-west1.firebasedatabase.app/',
    ),
  );
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => FirebaseProvider(),
        child: MaterialApp(
          home: AppWrapper(),
          debugShowCheckedModeBanner: false,
        ),
      );
}

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  late final TextEditingController myController;

  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        AuthLogin().updateOnlineStatus(
            FirebaseAuth.instance.currentUser?.uid, "online");
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        AuthLogin().updateOnlineStatus(
            FirebaseAuth.instance.currentUser?.uid, "offline");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    AuthLogin()
        .updateOnlineStatus(FirebaseAuth.instance.currentUser?.uid, "online");
    Widget initialScreen = user != null ? NavigationPage() : LoginForm();

    return MaterialApp(
      home: initialScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
