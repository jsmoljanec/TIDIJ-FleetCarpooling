import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AuthNotifyMe {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final StreamController<List<Map<String, dynamic>>>
      _notifyMeNotificationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get notifyMeNotificationStream =>
      _notifyMeNotificationStreamController.stream;

  AuthNotifyMe() {
    _subscribeToNotifyMeNotificationChanges();
  }

  void _subscribeToNotifyMeNotificationChanges() {
    _database.child('NotifyMeNotification').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          List<Map<String, dynamic>> notifyMeNotifications = [];
          DateTime now = DateTime.now();
          User? currentUser = _auth.currentUser;

          notifications.forEach((key, value) {
            if (value['email'] == currentUser?.email) {
              if (value['pickupDate'] != null) {
                DateTime pickupDate = DateTime.parse(value['pickupDate']);
                DateTime pickupDateTime = DateTime.parse(
                    '${value['pickupDate']} ${value['pickupTime']}');
                if (pickupDate.isAfter(now) &&
                    pickupDate.difference(now).inDays <= 2) {
                  if (!(pickupDate.isAtSameMomentAs(now) &&
                      pickupDateTime.isBefore(now))) {
                    _transferDataToNotificationTable(
                      value,
                      'Someone canceled for ${value['pickupDate']}. You can book from ${value['pickupTime']} to ${value['returnDate']} ${value['returnTime']}.',
                    );
                  }
                }
              }
            }
          });

          _notifyMeNotificationStreamController.add(notifyMeNotifications);
        }
      }
    });
  }

  Future<void> _transferDataToNotificationTable(
      Map<dynamic, dynamic> data, String message) async {
    try {
      DatabaseReference notificationRef = _database.child("Notification");

      DataSnapshot notificationTableSnapshot =
          (await notificationRef.once()) as DataSnapshot;
      if (notificationTableSnapshot.value == null) {
        await notificationRef.set({});
      }

      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
      // Uključivanje svih informacija u poruku
      data['message'] = message;
      await notificationRef.child(uniqueName).set(data);
    } catch (e) {
      throw Exception("Error transferring data to Notification table");
    }
  }

  Future<void> saveNotifyMeData(
    String vinCar,
    String pickupDate,
    String pickupTime,
    String returnDate,
    String returnTime,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

        Map<String, dynamic> notifyMeData = {
          'vinCar': vinCar,
          'email': user.email,
          'pickupDate': pickupDate,
          'pickupTime': formatTime(pickupTime),
          'returnDate': returnDate,
          'returnTime': formatTime(returnTime),
        };

        DatabaseReference notifyMeRef =
            _database.child("NotifyMe").child(uniqueName);
        await notifyMeRef.set(notifyMeData);
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      throw Exception("Error saving NotifyMe data");
    }
  }

  String formatTime(String time) {
    final dateTime = DateFormat('HH:mm').parse(time);
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> checkReservationDeletion(
    String vinCar,
    String reservationTimeStart,
    String reservationTimeEnd,
  ) async {
    try {
      DataSnapshot snapshot =
          (await _database.child("Reservation").once()).snapshot;

      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic> reservations = data ?? {};

      reservations.forEach((key, value) async {
        String reservationStart = value['reservationTimeStart'];
        String reservationEnd = value['reservationTimeEnd'];

        if (value['vinCar'] == vinCar &&
            timeRangesOverlap(reservationTimeStart, reservationTimeEnd,
                reservationStart, reservationEnd)) {
          await transferDataToNotificationTable(value);

          _database.child("NotifyMe").child(key).remove();
        }
      });
    } catch (e) {
      throw Exception("Error checking and notifying reservation deletion");
    }
  }

  bool timeRangesOverlap(
      String start1, String end1, String start2, String end2) {
    DateTime startTime1 = DateTime.parse(start1);
    DateTime endTime1 = DateTime.parse(end1);

    DateTime startTime2 = DateTime.parse(start2);
    DateTime endTime2 = DateTime.parse(end2);

    return endTime1.isAfter(startTime2) && startTime1.isBefore(endTime2);
  }

  Future<void> transferDataToNotificationTable(
      Map<dynamic, dynamic> data) async {
    try {
      DatabaseReference notifyMeNotificationRef =
          _database.child("NotifyMeNotification");

      DataSnapshot notificationTableSnapshot =
          (await notifyMeNotificationRef.once()) as DataSnapshot;
      if (notificationTableSnapshot.value == null) {
        await notifyMeNotificationRef.set({});
      }

      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
      await notifyMeNotificationRef.child(uniqueName).set(data);
    } catch (e) {
      throw Exception("Error transferring data to NotifyMeNotification table");
    }
  }

  Future<List<Map<String, dynamic>>> getNotifyMeNotifications(
      String userEmail) async {
    try {
      DateTime now = DateTime.now();

      DatabaseEvent snapshot = await _database
          .child('NotifyMeNotification')
          .orderByChild('email')
          .equalTo(userEmail)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          List<Map<String, dynamic>> notifyMeNotifications = [];
          notifications.forEach((key, value) {
            if (value['pickupDate'] != null) {
              DateTime pickupDate = DateTime.parse(value['pickupDate']);
              DateTime pickupDateTime = DateTime.parse(
                  '${value['pickupDate']} ${value['pickupTime']}');
              if (pickupDate.isAfter(now) &&
                  pickupDate.difference(now).inDays <= 2) {
                if (!(pickupDate.isAtSameMomentAs(now) &&
                    pickupDateTime.isBefore(now))) {
                  notifyMeNotifications.add({
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
          return notifyMeNotifications;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteAllUserNotifyMeNotifications(String userEmail) async {
    try {
      DatabaseEvent snapshot = await _database
          .child("NotifyMe")
          .orderByChild('email')
          .equalTo(userEmail)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          notifications.forEach((key, value) async {
            await _database.child('NotifyMe').child(key).remove();
          });
        }
      }
    } catch (e) {
      throw Exception('Error deleting all user NotifyMeNotifications: $e');
    }
  }
}
