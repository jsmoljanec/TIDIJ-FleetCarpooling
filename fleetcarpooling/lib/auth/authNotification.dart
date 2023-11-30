import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthNotification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Function(String) onNotificationReceived = (message) {};

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<List<Map<String, dynamic>>> getReservationsNotifications(
      String userEmail) async {
    try {
      DateTime now = DateTime.now();
      print('User Email: $userEmail');
      print('Datum: $now');

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
              if (pickupDate.difference(now).inDays <= 2) {
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
          });

          print('Snapshot: $snapshot');
          print('Reservations: $reservations');
          print('Notifications: $notifications');

          return notifications;
        }
      }

      return [];
    } catch (e) {
      print('Greška prilikom dohvaćanja rezervacija: $e');
      return [];
    }
  }
}
