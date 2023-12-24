import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthReservationNotification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final StreamController<List<Map<String, dynamic>>>
      _reservationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get reservationStream =>
      _reservationStreamController.stream;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  AuthReservationNotification() {
    _subscribeToReservationChanges();
  }

  void _subscribeToReservationChanges() {
    _databaseReference.child('Reservation').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? reservations =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (reservations != null) {
          DateTime now = DateTime.now();
          User? currentUser = getCurrentUser();

          reservations.forEach((key, value) {
            if (value['email'] == currentUser?.email) {
              if (value['pickupDate'] != null) {
                DateTime pickupDate = DateTime.parse(value['pickupDate']);
                DateTime pickupDateTime = DateTime.parse(
                    '${value['pickupDate']} ${value['pickupTime']}');
                if (pickupDate.isAfter(now) &&
                    pickupDate.difference(now).inDays <= 2) {
                  if (!(pickupDate.isAtSameMomentAs(now) &&
                      pickupDateTime.isBefore(now))) {
                    _saveNotificationToDatabase(
                      'You have a reservation for ${value['pickupDate']} from ${value['pickupTime']} until ${value['returnDate']} ${value['returnTime']}.',
                      value['vinCar']
                    );
                  }
                }
              }
            }
          });
        }
      }
    });
  }

  Future<void> _saveNotificationToDatabase(String message, String VinCar) async {
    try {
      User? currentUser = getCurrentUser();

      if (currentUser != null) {
        await _databaseReference.child('Notifications').push().set({
          'userEmail': currentUser.email,
          'message': message,
          'VinCar': VinCar,
        });
      }
    } catch (e) {
      throw Exception('Error saving notification to database');
    }
  }
}
