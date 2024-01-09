import 'package:fleetcarpooling/pages/admin_home_page.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/custom_toast.dart';
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

Widget buildText(String label, String value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32, 10.0, 32, 5),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
              color: AppColors.mainTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.mainTextColor,
            fontSize: 16,
          ),
        )
      ],
    ),
  );
}

Widget buildDialog(
    BuildContext context, String vin, bool active, String function) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(80, 28, 80, 28),
            child: Text(
              'ARE YOU SURE?',
              style: TextStyle(
                color: AppColors.mainTextColor,
                fontSize: 24,
              ),
            ),
          ),
          const Divider(
            height: 0.5,
            color: AppColors.mainTextColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  if (function == "disable") {
                    disableCar(vin, active);
                    Navigator.of(context).pop();

                    if (active) {
                      CustomToast()
                          .showFlutterToast("You succesfully disabled vehicle");
                    } else {
                      CustomToast().showFlutterToast(
                          "You succesfully activated vehicle");
                    }
                  } else {
                    deleteCar(vin);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminHomePage(),
                      ),
                    );
                    CustomToast()
                        .showFlutterToast("You succesfully deleted vehicle");
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'YES',
                    style: TextStyle(
                      color: AppColors.mainTextColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                width: 0.5,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainTextColor)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'NO',
                    style: TextStyle(
                      color: AppColors.mainTextColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _AdminSelectedVehiclePageState extends State<AdminSelectedVehiclePage> {
  final ReservationService service = ReservationService();
  final AuthReservationNotification authReservationNotification =
      AuthReservationNotification();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
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

              return SizedBox(
                height: screenHeight,
                child: Column(
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
                    Expanded(
                      child: Container(
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            buildText("Capacity", "${vehicle.capacity}"),
                            buildText("Distance traveled",
                                "${vehicle.distanceTraveled}"),
                            buildText("Fuel consumption",
                                "${vehicle.fuelConsumption}"),
                            buildText("Registration", vehicle.registration),
                            buildText("Transmission type", vehicle.transType),
                            buildText("Year", "${vehicle.year}"),
                            const Spacer(),
                            MyElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildDialog(context, vehicle.vin,
                                          vehicle.active, "disable");
                                    },
                                  );
                                },
                                label: vehicle.active ? "DISABLE" : "ACTIVATE"),
                            MyElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildDialog(context, vehicle.vin,
                                          vehicle.active, "delete");
                                    },
                                  );
                                },
                                label: "DELETE"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
