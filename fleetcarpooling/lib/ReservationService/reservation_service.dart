import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/Models/reservation_model.dart';
import 'package:fleetcarpooling/auth/auth_notify_me.dart';
import 'package:fleetcarpooling/auth/notification.dart';
import 'package:fleetcarpooling/auth/send_email.dart';
import 'package:fleetcarpooling/Models/terms_model.dart';
import 'package:fleetcarpooling/auth/user_repository.dart';
import 'package:flutter/material.dart';

abstract class ReservationRepository {
  Stream<List<Terms>> getReservationStream(String vinCar);
}

class ReservationService implements ReservationRepository {
  @override
  Stream<List<Terms>> getReservationStream(String vinCar) {
    final databaseReference = FirebaseDatabase.instance.ref();
    var query = databaseReference
        .child("Reservation")
        .orderByChild('VinCar')
        .equalTo(vinCar);

    return query.onValue.map((event) {
      List<Terms> termini = [];
      Map<dynamic, dynamic>? reservations =
          event.snapshot.value as Map<dynamic, dynamic>?;
      reservations?.forEach((key, value) {
        if (value['pickupDate'] != null) {
          DateTime pickupDate =
              DateTime.parse(value['pickupDate'] + ' ' + value['pickupTime']);
          pickupDate = pickupDate.subtract(const Duration(hours: 1));
          DateTime returnDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);
          termini.add(Terms(pickupDate, returnDate));
        }
      });
      return termini;
    });
  }

  Stream<List<Reservation>> getUserReservations(String userEmail) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Reservation");
    final StreamController<List<Reservation>> controller =
        StreamController<List<Reservation>>();

    ref
        .orderByChild('email')
        .equalTo(userEmail)
        .onValue
        .listen((DatabaseEvent event) {
      List<Reservation> userReservations = [];

      Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;
      values?.forEach((key, value) {
        try {
          String id = key;
          String vin = value['VinCar'] ?? '';
          String email = value['email'] ?? '';
          DateTime pickupDate = DateTime.parse(value['pickupDate'] ?? '');
          DateTime returnDate = DateTime.parse(value['returnDate'] ?? '');

          TimeOfDay parseTimeOfDay(String time) {
            List<int> parts = time.split(':').map(int.parse).toList();
            return TimeOfDay(hour: parts[0], minute: parts[1]);
          }

          TimeOfDay pickupTime = parseTimeOfDay(value['pickupTime'] ?? '');
          TimeOfDay returnTime = parseTimeOfDay(value['returnTime'] ?? '');

          userReservations.add(Reservation(
            id: id,
            vin: vin,
            email: email,
            pickupDate: pickupDate,
            returnDate: returnDate,
            pickupTime: pickupTime,
            returnTime: returnTime,
          ));
        } catch (e) {
          print('Error processing reservation data: $e');
        }
      });

      userReservations.sort((a, b) => b.pickupDate.compareTo(a.pickupDate));

      controller.add(userReservations);
    });
    return controller.stream;
  }

  Future<void> addReservation(
      String vin, DateTime pickupTime, DateTime returnTime) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    DatabaseReference reservationRef = database.child("Reservation");
    DatabaseReference newReservationRef = reservationRef.child(uniqueName);
    String pickupH;
    String returnH;
    String pickupDate =
        '${pickupTime.year}-${pickupTime.month.toString().padLeft(2, '0')}-${pickupTime.day.toString().padLeft(2, '0')}';
    String returnDate =
        '${returnTime.year}-${returnTime.month.toString().padLeft(2, '0')}-${returnTime.day.toString().padLeft(2, '0')}';
    if (pickupTime.hour >= 10) {
      pickupH = '${pickupTime.hour}:${pickupTime.minute}${pickupTime.second}';
    } else {
      pickupH = '0${pickupTime.hour}:${pickupTime.minute}${pickupTime.second}';
    }
    if (returnTime.hour >= 10) {
      returnH = '${returnTime.hour}:${returnTime.minute}${returnTime.second}';
    } else {
      returnH = '0${returnTime.hour}:${returnTime.minute}${returnTime.second}';
    }

    try {
      await newReservationRef.set({
        'VinCar': vin,
        'email': FirebaseAuth.instance.currentUser?.email,
        'pickupDate': pickupDate,
        'returnDate': returnDate,
        'pickupTime': pickupH,
        'returnTime': returnH,
      });
      print('Reservation added successfully!');
    } catch (error) {
      print("Error adding reservation: $error");
      throw error;
    }
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> confirmRegistration(
      String email, DateTime pickupDate, DateTime returnDate) async {
    String datePickup =
        "${pickupDate.year}-${_formatNumber(pickupDate.month)}-${_formatNumber(pickupDate.day)}";
    String timePickup =
        "${_formatNumber(pickupDate.hour)}:${_formatNumber(pickupDate.minute)}";

    String dateReturn =
        "${returnDate.year}-${_formatNumber(returnDate.month)}-${_formatNumber(returnDate.day)}";
    String timeReturn =
        "${_formatNumber(returnDate.hour)}:${_formatNumber(returnDate.minute)}";

    sendReservationEmail(email, datePickup, timePickup, dateReturn, timeReturn);
  }

  Future<bool> getReservationforCar(
      String vin, DateTime pickupTime, DateTime returnTime) async {
    List<Terms> termini = [];

    final databaseReference = FirebaseDatabase.instance.ref();
    var query = await databaseReference
        .child("Reservation")
        .orderByChild('VinCar')
        .equalTo(vin);

    DatabaseEvent snapshot = await query.once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? reservations =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      reservations?.forEach((key, value) {
        if (value['pickupDate'] != null) {
          DateTime pickupBusyDate =
              DateTime.parse(value['pickupDate'] + ' ' + value['pickupTime']);
          DateTime returnBusyDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);
          termini.add(Terms(pickupBusyDate, returnBusyDate));
        }
      });
    }

    print(termini);

    if (pickupTime.isBefore(returnTime)) {
      bool isAvailable = true;
      for (int i = 0; i < termini.length; i++) {
        if ((pickupTime.isBefore(termini[i].returnDate) &&
                returnTime.isAfter(termini[i].pickupDate)) ||
            (pickupTime.isBefore(termini[i].returnDate) &&
                returnTime.isAfter(termini[i].pickupDate))) {
          isAvailable = false;
          break;
        }
      }
      if (isAvailable) {
        print('Auto je dostupan!');
        return true;
      } else {
        print('Automobil nije dostupan u odabranom vremenskom razdoblju.');
        return false;
      }
    } else {
      print('Vrijeme povratka mora biti nakon vremena preuzimanja.');
      return false;
    }
  }

  Future<bool> checkReservationForUserAndCar(String vinCar, DateTime pickupTime,
      DateTime returnTime, String email) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    var query = databaseReference
        .child("Reservation")
        .orderByChild('VinCar')
        .equalTo(vinCar);

    DatabaseEvent snapshot = await query.once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? reservations =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;

      for (var entry in reservations!.entries) {
        var value = entry.value;
        if (value['pickupDate'] != null) {
          DateTime pickupBusyDate =
              DateTime.parse(value['pickupDate'] + ' ' + value['pickupTime']);
          DateTime returnBusyDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);

          if (value['email'] == email &&
              pickupBusyDate.isAtSameMomentAs(pickupTime) &&
              returnBusyDate.isAtSameMomentAs(returnTime)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  Future<bool> checkReservation(String email, String vinCar) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    var query = databaseReference
        .child("Reservation")
        .orderByChild('VinCar')
        .equalTo(vinCar);

    var snapshot = await query.once();

    Map<dynamic, dynamic>? reservations =
        snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (reservations != null) {
      DateTime currentDateTime = DateTime.now();

      for (var entry in reservations.entries) {
        var reservationData = entry.value as Map<dynamic, dynamic>;

        if (reservationData['email'] == email) {
          String pickupDate = reservationData['pickupDate'];
          String pickupTime = reservationData['pickupTime'];
          String returnDate = reservationData['returnDate'];
          String returnTime = reservationData['returnTime'];

          DateTime pickupDateTime = DateTime.parse('$pickupDate $pickupTime');
          DateTime returnDateTime = DateTime.parse('$returnDate $returnTime');

          if (currentDateTime.isAfter(pickupDateTime) &&
              currentDateTime.isBefore(returnDateTime)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  Future<void> checkAndDeleteReservation(String vinCar, DateTime pickupTime,
      DateTime returnTime, String email) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    var query = databaseReference
        .child("Reservation")
        .orderByChild('VinCar')
        .equalTo(vinCar);

    DatabaseEvent snapshot = await query.once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? reservations =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;

      for (var entry in reservations!.entries) {
        var value = entry.value;
        if (value['pickupDate'] != null &&
            value['pickupTime'] != null &&
            value['returnDate'] != null &&
            value['returnTime'] != null &&
            value['email'] == email) {
          DateTime pickupBusyDate =
              DateTime.parse(value['pickupDate'] + ' ' + value['pickupTime']);
          DateTime returnBusyDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);

          if (pickupBusyDate.isAtSameMomentAs(pickupTime) &&
              returnBusyDate.isAtSameMomentAs(returnTime)) {
            AuthNotifyMe notifyMe = AuthNotifyMe();
            await notifyMe.checkReservationDeletion(
                value['VinCar'],
                value['pickupDate'],
                value['returnDate'],
                value['pickupTime'],
                value['returnTime']);

            AuthNotification notifications = AuthNotification(FirebaseAuth.instance, FirebaseDatabase.instance);
            await notifications.deleteNotifications(
                value['VinCar'],
                value['returnDate'],
                value['returnTime'],
                value['pickupDate'],
                value['pickupTime']);

            String reservationKey = entry.key;
            await databaseReference
                .child("Reservation")
                .child(reservationKey)
                .remove();
          }
        }
      }
    }
  }

  Future<void> deleteReservation(String vin) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Reservation/$vin");

      DatabaseEvent snapshot = await ref.once();
      var reservationData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (reservationData != null) {
        AuthNotifyMe notifyMe = AuthNotifyMe();
        await notifyMe.checkReservationDeletion(
            reservationData['VinCar'],
            reservationData['pickupDate'],
            reservationData['returnDate'],
            reservationData['pickupTime'],
            reservationData['returnTime']);
      }

      await ref.remove();
    } catch (error) {
      print("Error deleting reservation: $error");
      rethrow;
    }
  }

  Future<void> deleteAllCarsReservation(String vin) async {
    try {
      final DatabaseReference _database = FirebaseDatabase.instance.ref();
      DatabaseEvent snapshot = await _database
          .child("Reservation")
          .orderByChild('VinCar')
          .equalTo(vin)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          notifications.forEach((key, value) async {
            await _database.child('Reservation').child(key).remove();
          });
        }
      }
    } catch (e) {
      throw Exception('Error deleting all user Reservation: $e');
    }
  }

  Future<void> deleteAllUserReservations(String email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Reservation");
    var query = ref.orderByChild('email').equalTo(email);

    var snapshot = await query.once();

    Map<dynamic, dynamic>? reservations =
        snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (reservations != null) {
      for (var entry in reservations.entries) {
        var reservationData = entry.value as Map<dynamic, dynamic>;

        if (reservationData['email'] == email) {
          String id = entry.key;
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("Reservation/$id");

          await ref.remove();
        }
      }
    }
  }

  Stream<List<Reservation>> getAllReservations() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Reservation");
    final StreamController<List<Reservation>> controller =
        StreamController<List<Reservation>>();

    ref.onValue.listen((DatabaseEvent event) async {
      List<Reservation> userReservations = [];

      Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        await Future.forEach(values.entries, (entry) async {
          try {
            String id = entry.key;
            String vin = entry.value['VinCar'] ?? '';
            String email = entry.value['email'] ?? '';

            UserRepository userRepository = UserRepository();
            String? name = await userRepository.getUserNameByEmail(email);

            DateTime pickupDate =
                DateTime.parse(entry.value['pickupDate'] ?? '');
            DateTime returnDate =
                DateTime.parse(entry.value['returnDate'] ?? '');

            TimeOfDay parseTimeOfDay(String time) {
              List<int> parts = time.split(':').map(int.parse).toList();
              return TimeOfDay(hour: parts[0], minute: parts[1]);
            }

            TimeOfDay pickupTime =
                parseTimeOfDay(entry.value['pickupTime'] ?? '');
            TimeOfDay returnTime =
                parseTimeOfDay(entry.value['returnTime'] ?? '');

            userReservations.add(Reservation(
              id: id,
              vin: vin,
              email: email,
              pickupDate: pickupDate,
              returnDate: returnDate,
              pickupTime: pickupTime,
              returnTime: returnTime,
              name: name,
            ));
          } catch (e) {
            print('Error processing reservation data: $e');
          }
        });
      }

      userReservations.sort((a, b) => b.pickupDate.compareTo(a.pickupDate));

      controller.add(userReservations);
    });

    return controller.stream;
  }
}
