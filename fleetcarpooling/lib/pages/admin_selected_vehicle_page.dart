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
