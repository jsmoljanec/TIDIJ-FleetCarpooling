// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthNotification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final StreamController<List<Map<String, dynamic>>>
      _notificationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get notificationStream =>
      _notificationStreamController.stream;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  AuthNotification() {
    _subscribeToNotificationChanges();
  }

  void _subscribeToNotificationChanges() {
    _databaseReference.child('Notifications').onValue.listen((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          User? currentUser = getCurrentUser();
          List<Map<String, dynamic>> userNotifications = [];

          for (var entry in notifications.entries) {
            var key = entry.key;
            var value = entry.value;

            if (value['email'] == currentUser?.email) {
              // Dohvati dodatne informacije o automobilu iz tablice Vehicles
              Map<String, dynamic>? carDetails =
                  await getCarDetails(value['VinCar']);

              if (carDetails != null) {
                userNotifications.add({
                  'key': key,
                  'message': value['message'],
                  'VinCar': value['VinCar'],
                  'pickupDate': value['pickupDate'],
                  'pickupTime': value['pickupTime'],
                  'returnDate': value['returnDate'],
                  'returnTime': value['returnTime'],
                  'model': carDetails['model'],
                  'brand': carDetails['brand'],
                  'year': carDetails['year'],
                });
              }
            }
          }

          _notificationStreamController.add(userNotifications);
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      DatabaseEvent snapshot =
          await _databaseReference.child('Notifications').once();

      // ignore: unnecessary_null_comparison
      if (snapshot.snapshot != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          User? currentUser = getCurrentUser();
          List<Map<String, dynamic>> userNotifications = [];

          notifications.forEach((key, value) {
            if (value['email'] == currentUser?.email) {
              userNotifications.add({
                'key': key,
                'message': value['message'],
                'VinCar': value['VinCar'],
                'pickupDate': value['pickupDate'],
                'pickupTime': value['pickupTime'],
                'returnDate': value['returnDate'],
                'returnTime': value['returnTime']
              });
            }
          });

          return userNotifications;
        }
      }

      return [];
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<Map<String, dynamic>?> getCarDetails(String vinCar) async {
    try {
      DatabaseEvent snapshot =
          await _databaseReference.child('Vehicles').child(vinCar).once();

      // ignore: unnecessary_null_comparison
      if (snapshot.snapshot != null) {
        Map<Object?, Object?>? carDetails =
            snapshot.snapshot.value as Map<Object?, Object?>?;

        if (carDetails != null) {
          Map<String, dynamic> carDetailsMap =
              Map<String, dynamic>.from(carDetails);
          return carDetailsMap;
        }
      }

      throw Exception('Car details not found');
    } catch (e) {
      throw Exception('Error fetching car details: $e');
    }
  }
}
