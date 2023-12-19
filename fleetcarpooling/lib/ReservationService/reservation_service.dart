import 'package:firebase_auth/firebase_auth.dart';
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
          pickupDate = pickupDate.subtract(Duration(hours: 1));
          DateTime returnDate =
              DateTime.parse(value['returnDate'] + ' ' + value['returnTime']);
          termini.add(Terms(pickupDate, returnDate));
        }
      });
      return termini;
    });
  }

  Future<void> addReservation(
      String vin, DateTime pickupTime, DateTime returnTime) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    DatabaseReference reservationRef = database.child("Reservation");
    DatabaseReference newReservationRef = reservationRef.child(uniqueName);
    String pickupH;
    String pickupDate =
        '${pickupTime.year}-${pickupTime.month}-${pickupTime.day}';
    String returnDate =
        '${returnTime.year}-${returnTime.month}-${returnTime.day}';
    if (pickupTime.hour >= 10) {
      pickupH = '${pickupTime.hour}:${pickupTime.minute}${pickupTime.second}';
    } else {
      pickupH = '0${pickupTime.hour}:${pickupTime.minute}${pickupTime.second}';
    }
    String returnH =
        '${returnTime.hour}:${returnTime.minute}${returnTime.second}';
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
}
