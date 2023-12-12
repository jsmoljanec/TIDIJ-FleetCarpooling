import 'package:firebase_database/firebase_database.dart';

import '../Models/terms_model.dart';

abstract class ReservationRepository {
  Future<List<Terms>> getReservation(String vinCar);
}

class ReservationService implements ReservationRepository {
  @override
  Future<List<Terms>> getReservation(String vinCar) async {
    List<Terms> termini = [];
    final databaseReference = FirebaseDatabase.instance.ref();
    var query = await databaseReference
        .child("Reservation")
        .orderByChild('VinCar')
        .equalTo(vinCar);

    DatabaseEvent snapshot = await query.once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? reservations =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      reservations?.forEach((key, value) {
        if (value['pickupDate'] != null) {
          DateTime pickupDate =
              DateTime.parse(value['pickupDate'] + ' ' + value['pickupTime']);
          DateTime returnDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);
          termini.add(Terms(pickupDate, returnDate));
        }
      });
    }
    return termini;
  }
}
