import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/send_email.dart';
import 'package:fleetcarpooling/Models/terms_model.dart';

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
