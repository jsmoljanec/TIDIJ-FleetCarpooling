import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/auth/authReservationNotification.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';

class AdminSelectedVehiclePage extends StatefulWidget {
  final String vin;

  const AdminSelectedVehiclePage({
    Key? key,
    required this.vin,
  }) : super(key: key);

  @override
  State<AdminSelectedVehiclePage> createState() =>
      _AdminSelectedVehiclePageState();
}

class _AdminSelectedVehiclePageState extends State<AdminSelectedVehiclePage> {
  final ReservationService service = ReservationService();
  final AuthReservationNotification authReservationNotification =
      AuthReservationNotification();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Vehicle?>(
              stream: getVehicle(widget.vin),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                Vehicle vehicle = snapshot.data!;

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
                            "${vehicle.brand} ${vehicle.model}",
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.mainTextColor,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Image.network(
                      vehicle.imageUrl,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 300,
                    ),
                    Container(
                      width: screenWidth,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border(
                          top: BorderSide(color: AppColors.mainTextColor),
                          left: BorderSide(color: AppColors.mainTextColor),
                          right: BorderSide(color: AppColors.mainTextColor),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Capacity: ${vehicle.capacity}",
                            style: const TextStyle(
                              color: AppColors.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Distance traveled: ${vehicle.distanceTraveled}",
                            style: const TextStyle(
                              color: AppColors.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Fuel consumption: ${vehicle.fuelConsumption}l/100km",
                            style: const TextStyle(
                              color: AppColors.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Registration: ${vehicle.registration}",
                            style: const TextStyle(
                              color: AppColors.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Transtype: ${vehicle.transType}",
                            style: const TextStyle(
                              color: AppColors.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Year: ${vehicle.year}",
                            style: const TextStyle(
                              color: AppColors.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}





                      // child: Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
                      //       child: Row(
                      //         children: [
                      //           SizedBox(
                      //             height: 20,
                      //             width: 20,
                      //             child: Image.asset("assets/icons/fuel.png"),
                      //           ),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.only(left: 8.0, top: 4),
                      //             child: Text(
                      //               "${vehicle.fuelConsumption} l/100km",
                      //               style: const TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.w700,
                      //                 color: AppColors.mainTextColor,
                      //               ),
                      //             ),
                      //           ),
                      //           const Spacer(),
                      //           SizedBox(
                      //             width: 20,
                      //             height: 20,
                      //             child:
                      //                 Image.asset("assets/icons/distance.png"),
                      //           ),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.only(left: 8.0, top: 4),
                      //             child: Text(
                      //               "${vehicle.distanceTraveled} km",
                      //               style: const TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.w700,
                      //                 color: AppColors.mainTextColor,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),