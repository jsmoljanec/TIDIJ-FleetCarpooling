import 'dart:async';
import 'dart:convert';
import 'package:fleetcarpooling/chat/pages/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

class NotificationsService {
  static const key =
      'AAAA3qcR1dM:APA91bHXwf9Efc-9arDjVLTUnC6tIf7Ultk_uCkc6WVahtKx8xe-dEdcnICRPjoGBDNIlXrOM6TZ74wrus7bcLugZ-M3_-ttOu7iSD6FHGU6RT3GXYpDNbKpkrNo47wnbCG0X_w8WYJq';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint(response.payload.toString());
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
      'com.example.chat_app.urgent',
      'mychannelid',
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.max,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data['body'],
    );
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken(String receiverId) async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!, receiverId);
  }

  Future<void> _saveToken(String token, String receiverId) async {
    DatabaseReference vehicleRef =
        _database.child("Vehicles").child(receiverId).child("token");
    vehicleRef.update({token: token});
  }

  List<String> receiverToken = [];

  Future<void> getReceiverToken(String? receiverId) async {
    List<String> token = [];
    print(receiverId);
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("Vehicles")
        .child(receiverId!)
        .child("token");
    DatabaseEvent snapshot = await ref.once();
    Map<dynamic, dynamic>? values =
        snapshot.snapshot.value as Map<dynamic, dynamic>?;
    values?.forEach((key, value) {
      String tokenValue = value.toString();
      if (!token.contains(tokenValue)) {
        token.add(tokenValue);
      }
    });
    receiverToken = token;
  }

  Future<void> sendNotification(
      {required String body, required String senderId}) async {
    for (int i = 0; i < receiverToken.length; i++) {
      if (receiverToken[i] == await FirebaseMessaging.instance.getToken()) {
      } else {
        try {
          await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$key',
            },
            body: jsonEncode(<String, dynamic>{
              "to": receiverToken[i],
              'priority': 'high',
              'notification': <String, dynamic>{
                'body': body,
                'title': 'New Message !',
              },
              'data': <String, String>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'senderId': senderId,
              }
            }),
          );
          print("poslan poruka na ${receiverToken[i]}");
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> deleteToken() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    final token = await FirebaseMessaging.instance.getToken();
    var query = await ref
        .child("Vehicles")
        .orderByChild('token/${token}')
        .equalTo(token)
        .once();
    print(token);
    DataSnapshot snapshot = query.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      if (values != null) {
        values.forEach((key, value) {
          print(key);
          if (value is Map && value['token'][token] == token) {
            ref
                .child('Vehicles')
                .child(key)
                .child('token')
                .child(token!)
                .remove();
          }
        });
      }
    }
  }

  void firebaseNotification(BuildContext context) {
    _initLocalNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            vin: "",
            brand: "",
            model: "",
          ),
        ),
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });
  }
}
