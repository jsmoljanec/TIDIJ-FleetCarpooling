import 'package:core/ui_elements/colors';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/pages/admin_home_page.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:fleetcarpooling/pages/login_form.dart';
import 'package:fleetcarpooling/pages/navigation.dart';
import 'package:provider/provider.dart';
import 'package:fleetcarpooling/pages/reservation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
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
}

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
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  await dotenv.load(fileName: ".env");

  User? user = FirebaseAuth.instance.currentUser;
  Widget initialScreen = user != null
      ? NavigationPage(returnTime: DateTime.now(), pickupTime: DateTime.now())
      : LoginForm();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final TextEditingController myController = TextEditingController();
  final Widget initialScreen;

  MyApp({required this.initialScreen, super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => FirebaseProvider(),
        child: MaterialApp(
          home: AppWrapper(initialScreen: initialScreen),
          debugShowCheckedModeBanner: false,
        ),
      );
}

class AppWrapper extends StatefulWidget {
  final Widget initialScreen;

  AppWrapper({required this.initialScreen});

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  late final TextEditingController myController;
  final AuthLogin _authLogin = AuthLogin();

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
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => FirebaseProvider(),
        child: MaterialApp(
          home: FutureBuilder<bool>(
            future: _authLogin.isAdmin(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Scaffold(
                    backgroundColor: AppColors.backgroundColor,
                    body: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return snapshot.data == true
                        ? AdminHomePage()
                        : widget.initialScreen;
                  }
                default:
                  return const Text('Unexpected ConnectionState');
              }
            },
          ),
          debugShowCheckedModeBanner: false,
        ),
      );
}
