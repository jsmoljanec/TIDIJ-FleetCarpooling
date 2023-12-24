import 'package:flutter/material.dart';

class Reservation {
  final String vin;
  final String email;
  final DateTime pickupDate;
  final DateTime returnDate;
  final TimeOfDay pickupTime;
  final TimeOfDay returnTime;

  Reservation({
    required this.vin,
    required this.email,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupTime,
    required this.returnTime,
  });



}
