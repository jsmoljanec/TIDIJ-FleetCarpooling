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

String getShortWeekday(DateTime dateTime) {
  switch (dateTime.weekday) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '';
  }
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
        padding: const EdgeInsets.only(top: 25),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.buttonColor))),
                    margin: const EdgeInsets.only(bottom: 28),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "MY RESERVATIONS",
                        style: TextStyle(
                            color: AppColors.mainTextColor, fontSize: 24),
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
                        return const Center(
                            child: Text('No reservations made yet.'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<String?>(
                            future: getVehicleModelAndBrand(
                                snapshot.data![index].vin),
                            builder: (context, snapshotInfo) {
                              if (snapshotInfo.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Column(children: [
                                        Text(
                                          snapshotInfo.data ??
                                              "Could not fetch car informations",
                                          style: const TextStyle(
                                              color: AppColors.mainTextColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, bottom: 12),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${getShortWeekday(snapshot.data![index].pickupDate)}, ${snapshot.data![index].pickupDate.day}. ${snapshot.data![index].pickupDate.month}",
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.mainTextColor,
                                                    fontSize: 16),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: AppColors.mainTextColor,
                                                size: 16,
                                              ),
                                              Text(
                                                  "${getShortWeekday(snapshot.data![index].returnDate)}, ${snapshot.data![index].returnDate.day}. ${snapshot.data![index].returnDate.month}",
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .mainTextColor,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 0.5,
                                          color: AppColors.mainTextColor,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(
                                                top: 12, bottom: 24),
                                            child: InkWell(
                                              child: Text(
                                                "Cancel reservation",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.mainTextColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ))
                                      ]),
                                    ),
                                  ));
                            },
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
