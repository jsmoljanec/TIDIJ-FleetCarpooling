import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthNotification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final StreamController<List<Map<String, dynamic>>> _reservationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get reservationStream =>
      _reservationStreamController.stream;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  AuthNotification() {
    _subscribeToReservationChanges();
  }

  void _subscribeToReservationChanges() {
    _databaseReference.child('Reservation').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? reservations =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (reservations != null) {
          List<Map<String, dynamic>> notifications = [];
          DateTime now = DateTime.now();

          reservations.forEach((key, value) {
            if (value['pickupDate'] != null) {
              DateTime pickupDate = DateTime.parse(value['pickupDate']);
              DateTime pickupDateTime = DateTime.parse(
                  '${value['pickupDate']} ${value['pickupTime']}');
              if (pickupDate.isAfter(now) &&
                  pickupDate.difference(now).inDays <= 2) {
                if (!(pickupDate.isAtSameMomentAs(now) &&
                    pickupDateTime.isBefore(now))) {
                  notifications.add({
                    'key': key,
                    'VinCar': value['VinCar'],
                    'pickupDate': value['pickupDate'],
                    'pickupTime': value['pickupTime'],
                    'returnDate': value['returnDate'],
                    'returnTime': value['returnTime'],
                  });
                }
              }
            }
          });

          _reservationStreamController.add(notifications);
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> getReservationsNotifications(
      String userEmail) async {
    try {
      DateTime now = DateTime.now();

      DatabaseEvent snapshot = await _databaseReference
          .child('Reservation')
          .orderByChild('email')
          .equalTo(userEmail)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? reservations =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (reservations != null) {
          List<Map<String, dynamic>> notifications = [];
          reservations.forEach((key, value) {
            if (value['pickupDate'] != null) {
              DateTime pickupDate = DateTime.parse(value['pickupDate']);
              DateTime pickupDateTime = DateTime.parse(
                  '${value['pickupDate']} ${value['pickupTime']}');
              if (pickupDate.isAfter(now) &&
                  pickupDate.difference(now).inDays <= 2) {
                if (!(pickupDate.isAtSameMomentAs(now) &&
                    pickupDateTime.isBefore(now))) {
                  notifications.add({
                    'key': key,
                    'VinCar': value['VinCar'],
                    'pickupDate': value['pickupDate'],
                    'pickupTime': value['pickupTime'],
                    'returnDate': value['returnDate'],
                    'returnTime': value['returnTime'],
                  });
                }
              }
            }
          });
          return notifications;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
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