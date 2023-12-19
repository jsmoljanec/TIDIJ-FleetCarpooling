import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';

class SelectedVehiclePage extends StatefulWidget {
  final String vin;
  const SelectedVehiclePage({Key? key, required this.vin}) : super(key: key);

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  final ReservationService _reservationService = ReservationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<Vehicle?>(
              stream: getVehicle(widget.vin),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          CircularIconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "${snapshot.data!.brand} ${snapshot.data!.model}",
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.mainTextColor,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset("assets/icons/chat.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      snapshot.data!.imageUrl,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 300,
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          border: Border.all(
                            color: AppColors.mainTextColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 28, 32, 20),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset("assets/icons/fuel.png"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 4),
                                    child: Text(
                                      "${snapshot.data!.fuelConsumption} l/100km",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.mainTextColor),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                          "assets/icons/distance.png")),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 4),
                                    child: Text(
                                      "${snapshot.data!.distanceTraveled} km",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.mainTextColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            MyCalendar(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                            ),
                            MyElevatedButton(
                              onPressed: () async {
                                await _reservationService.addReservation(
                                    "wwww",
                                    "iva.plavsic2@gmail.com",
                                    DateTime.now(),
                                    DateTime(2023, 12, 31, 23, 59, 59),
                                    TimeOfDay.now(),
                                    const TimeOfDay(hour: 12, minute: 30));
                              },
                              label: "MAKE A RESERVATION",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
