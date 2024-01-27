import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';
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
    String vinCar,
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

          String notifyMeStart = _formatDate(entry.value['pickupDate']);
          String notifyMeEnd = _formatDate(entry.value['returnDate']);
          String notifyMeTimeStart = entry.value['pickupTime'];
          String notifyMeTimeEnd = entry.value['returnTime'];

          print("vinCar: $vinCar");
          print("reservationDateStart: $reservationDateStart");
          print("reservationDateEnd: $reservationDateEnd");
          print("notifyMeStart: $notifyMeStart");
          print("notifyMeEnd: $notifyMeEnd");

          if (entry.value['VinCar'] == vinCar &&
              await timeRangesOverlap(
                  reservationDateStart,
                  reservationDateEnd,
                  notifyMeStart,
                  notifyMeEnd,
                  reservationTimeStart,
                  reservationTimeEnd,
                  notifyMeTimeStart,
                  notifyMeTimeEnd,
                  vinCar)) {
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

  Future<bool> timeRangesOverlap(
  String reservationDateStart,
  String reservationDateEnd,
  String notifyMeStart,
  String notifyMeEnd,
  String reservationTimeStart,
  String reservationTimeEnd,
  String notifyMeTimeStart,
  String notifyMeTimeEnd,
  String vinCar,
) async {
  try {
    print("Reservation Date Start: $reservationDateStart");
    print("Reservation Date End: $reservationDateEnd");
    print("NotifyMe Date Start: $notifyMeStart");
    print("NotifyMe Date End: $notifyMeEnd");
    print("Reservation Time Start: $reservationTimeStart");
    print("Reservation Time End: $reservationTimeEnd");
    print("NotifyMe Time Start: $notifyMeTimeStart");
    print("NotifyMe Time End: $notifyMeTimeEnd");

    DateTime range1StartDate = DateTime.parse(reservationDateStart);
    DateTime range1EndDate = DateTime.parse(reservationDateEnd);
    DateTime range2StartDate = DateTime.parse(notifyMeStart);
    DateTime range2EndDate = DateTime.parse(notifyMeEnd);
    DateTime range1EndTime = DateFormat('HH:mm').parse(reservationTimeEnd);
    DateTime range2EndTime = DateFormat('HH:mm').parse(notifyMeTimeEnd);

    ReservationService reservationService = ReservationService();
    bool? noReservation;

    print("Before checkReservationOverlap");
    noReservation = await reservationService.checkReservationOverlap(
      vinCar,
      notifyMeEnd,
      notifyMeTimeEnd,
    );
    print("After checkReservationOverlap");

    if ((range2StartDate.isAfter(range1StartDate) ||
            range2StartDate.isAtSameMomentAs(range1StartDate)) &&
        range1EndDate.isBefore(range2StartDate)) {
      if (range2EndDate.isAfter(range1EndDate)) {
        print("Condition 1");
      } else if (range2EndDate.isAtSameMomentAs(range1EndDate)) {
        if (range1EndTime.isAfter(range2EndTime) ||
            range1EndTime.isAtSameMomentAs(range2EndTime)) {
          print("Condition 2");
        } else if (range1EndTime.isBefore(range2EndTime)) {
          print("Condition 3");
        }
      }
    }

    print("Returning result: $noReservation");
    return noReservation;
  } catch (e) {
    print("Error in timeRangesOverlap: $e");
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
      String formattedTime = time.padLeft(5, '0');
      DateTime parsedTime = DateFormat('HH:mm').parse(formattedTime);
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
