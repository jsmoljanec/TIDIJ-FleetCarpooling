import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/Models/reservation_model.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
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
  late Stream<List<Reservation>> _reservationsStream;

  @override
  Widget build(BuildContext context) {
    _reservationsStream = _service.getUserReservations(user!.email!);

    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    // double padding2 = screenHeight * 0.02;

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
          SingleChildScrollView(
            child: Center(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.buttonColor))),
                child: const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "MY RESERVATIONS",
                    style:
                        TextStyle(color: AppColors.mainTextColor, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<List<Reservation>>(
            stream: _reservationsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No reservations made yet.'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<String?>(
                    future: getVehicleModelAndBrand(snapshot.data![index].vin),
                    builder: (context, snapshotInfo) {
                      if (snapshotInfo.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      return Text(snapshotInfo.data ??
                          "Could not fetch car informations");
                    },
                  );
                },
              );
            },
          )
        ],
      ),
    ));
  }
}
