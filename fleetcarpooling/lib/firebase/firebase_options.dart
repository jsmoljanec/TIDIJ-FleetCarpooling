// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDKdXry4e10t-BOiyZSgS3RW36R6_lUI-Y',
    appId: '1:956285703635:web:02e99568719cf499d58b26',
    messagingSenderId: '956285703635',
    projectId: 'fleetcarpooling-cd243',
    authDomain: 'fleetcarpooling-cd243.firebaseapp.com',
    storageBucket: 'fleetcarpooling-cd243.appspot.com',
    measurementId: 'G-8GZHNM03VL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiAzExpBKwIfaYhntOua3f7qNMJ5ecdA0',
    appId: '1:956285703635:android:1faaaa1cfb6be0d4d58b26',
    messagingSenderId: '956285703635',
    projectId: 'fleetcarpooling-cd243',
    storageBucket: 'fleetcarpooling-cd243.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQsxiuyVKrYRWljl_0L53UlYtXFwpZdZY',
    appId: '1:956285703635:ios:84ec4937d952c038d58b26',
    messagingSenderId: '956285703635',
    projectId: 'fleetcarpooling-cd243',
    storageBucket: 'fleetcarpooling-cd243.appspot.com',
    iosBundleId: 'com.example.fleetcarpooling',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQsxiuyVKrYRWljl_0L53UlYtXFwpZdZY',
    appId: '1:956285703635:ios:4d16e2b1a87db2bfd58b26',
    messagingSenderId: '956285703635',
    projectId: 'fleetcarpooling-cd243',
    storageBucket: 'fleetcarpooling-cd243.appspot.com',
    iosBundleId: 'com.example.fleetcarpooling.RunnerTests',
  );
}
