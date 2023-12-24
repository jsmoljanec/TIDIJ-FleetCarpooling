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
    _databaseReference.child('Notifications').onValue.listen((event) {
      print('Notification changes detected');
      print('Snapshot value: ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          User? currentUser = getCurrentUser();
          List<Map<String, dynamic>> userNotifications = [];

          notifications.forEach((key, value) {
            if (value['email'] == currentUser?.email) {
              String message = value['message'];
              String vinCar = value['VinCar'];

              userNotifications.add({
                'key': key,
                'message': message,
                'vinCar': vinCar,
              });
            }
          });

          print('Notifications: ${userNotifications}');
          _notificationStreamController.add(userNotifications);
        }
      }
    });
  }

  Future<Map<String, dynamic>?> getCarDetails(String vinCar) async {
    try {
      DatabaseEvent snapshot =
          await _databaseReference.child('Vehicles').child(vinCar).once();

      if (snapshot.snapshot.value != null) {
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
      throw Exception('Error fetching car details');
    }
  }
}
