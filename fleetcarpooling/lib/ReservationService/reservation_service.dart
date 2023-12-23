import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/send_email.dart';

import '../Models/terms_model.dart';

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
}
