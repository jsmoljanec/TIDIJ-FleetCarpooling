import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReservationService {
  Future<void> addReservation(String vin, String email, DateTime pickupDate,
      DateTime returnDate, TimeOfDay pickupTime, TimeOfDay returnTime) async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();
    DatabaseReference reservationRef = database.child("Reservation");
    DatabaseReference newReservationRef = reservationRef.child(vin);

    try {
      await newReservationRef.set({
        'vin': vin,
        'email': email,
        'pickupDate': pickupDate.toIso8601String(),
        'returnDate': returnDate.toIso8601String(),
        'pickupTime': _timeOfDayToMap(pickupTime),
        'returnTime': _timeOfDayToMap(returnTime),
      });
      print('Reservation added successfully!');
    } catch (error) {
      print("Error adding reservation: $error");
      throw error;
    }
  }

  Map<String, dynamic> _timeOfDayToMap(TimeOfDay timeOfDay) {
    return {'hour': timeOfDay.hour, 'minute': timeOfDay.minute};
  }
}
