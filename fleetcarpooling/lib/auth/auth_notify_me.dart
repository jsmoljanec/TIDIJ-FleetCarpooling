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
    //_subscribeToNotifyMeNotificationChanges();
  }

  Future<void> saveNotifyMeData(
    String VinCar,
    String pickupDate,
    String pickupTime,
    String returnDate,
    String returnTime,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
        print("");

        Map<String, dynamic> notifyMeData = {
          'VinCar': VinCar,
          'email': user.email,
          'pickupDate': _formatDate(pickupDate),
          'pickupTime': _formatTime(pickupTime),
          'returnDate': _formatDate(returnDate),
          'returnTime': _formatTime(returnTime),
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

  Future<void> checkReservationDeletion(
    String VinCar,
    String reservationDateStart,
    String reservationDateEnd,
    String reservationTimeStart,
    String reservationTimeEnd,
  ) async {
    print("checkReservationDeletion called!");
    try {
      DataSnapshot snapshot =
          (await _database.child("NotifyMe").once()).snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        print("Data is not null");
        for (var entry in data.entries) {
          print("Checking entry: $entry");

          String notifyMeStart = entry.value['pickupDate'];
          String notifyMeEnd = entry.value['returnDate'];

          print("vinCar: $VinCar");
          print("reservationDateStart: $reservationDateStart");
          print("reservationDateEnd: $reservationDateEnd");
          print("notifyMeStart: $notifyMeStart");
          print("notifyMeEnd: $notifyMeEnd");

          if (entry.value['VinCar'] == VinCar &&
              timeRangesOverlap(
                reservationDateStart,
                reservationDateEnd,
                notifyMeStart,
                notifyMeEnd,
              )) {
            print("Condition satisfied for entry: $entry");
            await transferDataToNotificationTable(entry.value);
            await _database.child("NotifyMe").child(entry.key).remove();
          } else {
            print("Condition not satisfied for entry: $entry");
          }
        }
      }
    } catch (e) {
      print("Error in checkReservationDeletion: $e");
      throw Exception("Error checking and notifying reservation deletion");
    }
  }

  bool timeRangesOverlap(
    String reservationDateStart,
    String reservationDateEnd,
    String notifyMeStart,
    String notifyMeEnd,
  ) {
    try {
      DateTime range1StartTime = DateTime.parse(reservationDateStart);
      DateTime range1EndTime = DateTime.parse(reservationDateEnd);
      DateTime range2StartTime = DateTime.parse(notifyMeStart);
      DateTime range2EndTime = DateTime.parse(notifyMeEnd);

      return range1EndTime.isAfter(range2StartTime) &&
          range1StartTime.isBefore(range2EndTime);
    } catch (e) {
      print("Error parsing date: $e");
      return false;
    }
  }

  Future<void> transferDataToNotificationTable(
      Map<dynamic, dynamic> data) async {
    try {
      print("Transferring data to NotifyMeNotification table: $data");
      DatabaseReference notifyMeNotificationRef =
          _database.child("Notifications");

      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> notificationData = {
        'VinCar': data['VinCar'],
        'email': data['email'],
        'pickupDate': _formatDate(data['pickupDate']),
        'pickupTime': _formatTime(data['pickupTime']),
        'returnDate': _formatDate(data['returnDate']),
        'returnTime': _formatTime(data['returnTime']),
        'message':
            "Someone canceled for ${_formatDate(data['pickupDate'])}. You can book from ${_formatTime(data['pickupTime'])} to ${_formatDate(data['returnDate'])} ${_formatTime(data['returnTime'])}.",
      };

      await notifyMeNotificationRef.child(uniqueName).set(notificationData);
      print("Data successfully transferred to NotifyMeNotification table.");
    } catch (e) {
      print("Error transferring data to NotifyMeNotification table: $e");
      throw Exception("Error transferring data to NotifyMeNotification table");
    }
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String _formatTime(String time) {
    try {
      DateTime parsedTime = DateFormat('HH:mm').parse(time);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      print("Error formatting time: $e");
      return time; 
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

  Future<void> deleteAllCarsNotifyMeNotifications(String vin) async {
    try {
      DatabaseEvent snapshot = await _database
          .child("NotifyMe")
          .orderByChild('vinCar')
          .equalTo(vin)
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
