import 'package:firebase_database/firebase_database.dart';

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
          DateTime returnDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);
          termini.add(Terms(pickupDate, returnDate));
        }
      });
      return termini;
    });
  }
}
