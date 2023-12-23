import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/send_email.dart';
import 'package:intl/intl.dart';

class AuthNotifyMe {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

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

  Future<void> checkAndNotifyReservationDeletion(
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
          await sendNotifyMeEmail(
            value['vinCar'],
            value['pickupDate'],
            value['pickupTime'],
            value['returnDate'],
            value['returnTime'],
          );

          await transferDataToNotificationTable(value);

          _database.child("NotifyMe").child(key).remove();
        }
      });
    } catch (e) {
      throw Exception("Error checking and notifying reservation deletion");
    }
  }

  bool timeRangesOverlap(String start1, String end1, String start2, String end2) {
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
}
