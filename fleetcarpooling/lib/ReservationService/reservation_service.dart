import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReservationService {
  Future<void> addReservation(String vin, String emailDir, DateTime pickupTime,
      DateTime returnTime) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    DatabaseReference reservationRef = database.child("Reservation");
    DatabaseReference newReservationRef = reservationRef.child(uniqueName);

    String pickupDate =
        '${pickupTime.year}-${pickupTime.month}-${pickupTime.day}';
    String returnDate =
        '${returnTime.year}-${returnTime.month}-${returnTime.day}';
    String pickupH =
        '${pickupTime.hour}:${pickupTime.minute}${pickupTime.second}';
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
