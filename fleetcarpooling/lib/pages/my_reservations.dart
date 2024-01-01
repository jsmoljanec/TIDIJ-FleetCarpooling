import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  late final ReservationService _service = ReservationService();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    // double padding2 = screenHeight * 0.02;

    Stream<List<String>> reservations =
        _service.getUserReservationsStream(user!.email!);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 450),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.buttonColor))),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "MY RESERVATIONS",
                style: TextStyle(color: AppColors.mainTextColor, fontSize: 24),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
