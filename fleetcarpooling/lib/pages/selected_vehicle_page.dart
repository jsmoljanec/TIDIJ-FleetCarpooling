import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/auth/authReservationNotification.dart';
import 'package:fleetcarpooling/pages/notify_me_page.dart';
import 'package:fleetcarpooling/chat/pages/chat_screen.dart';
import 'package:fleetcarpooling/pages/reservation_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';

class SelectedVehiclePage extends StatefulWidget {
  final String vin;
  final bool isFree;
  final DateTime pickupTime;
  final DateTime returnTime;

  const SelectedVehiclePage({
    Key? key,
    required this.vin,
    required this.isFree,
    required this.pickupTime,
    required this.returnTime,
  }) : super(key: key);

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  final ReservationService service = ReservationService();
  final AuthReservationNotification authReservationNotification =
      AuthReservationNotification();
  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Vehicle?>(
              stream: getVehicle(widget.vin),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
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
                          Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      vin: vehicle.vin,
                                      brand: vehicle.brand,
                                      model: vehicle.model,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset("assets/icons/chat.png"),
                            ),
                          ),
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/icons/fuel.png"),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 4),
                                  child: Text(
                                    "${vehicle.fuelConsumption} l/100km",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mainTextColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      Image.asset("assets/icons/distance.png"),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 4),
                                  child: Text(
                                    "${vehicle.distanceTraveled} km",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mainTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(),
                border: Border(
                  left: BorderSide(color: AppColors.mainTextColor),
                  right: BorderSide(color: AppColors.mainTextColor),
                ),
              ),
              child: MyCalendar(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  vin: widget.vin),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(),
                border: Border(
                  left: BorderSide(color: AppColors.mainTextColor),
                  right: BorderSide(color: AppColors.mainTextColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      "Change date",
                      style: TextStyle(
                        color: AppColors.mainTextColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.mainTextColor,
                        decorationThickness: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(),
                border: Border(
                  left: BorderSide(color: AppColors.mainTextColor),
                  right: BorderSide(color: AppColors.mainTextColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: MyElevatedButton(
                  onPressed: () async {
                    if (widget.isFree == true) {
                      await service.addReservation(
                        widget.vin,
                        widget.pickupTime,
                        widget.returnTime,
                      );
                      await service.confirmRegistration(
                        email,
                        widget.pickupTime,
                        widget.returnTime,
                      );
                      await authReservationNotification
                          .saveNotificationToDatabase({
                        'vinCar': widget.vin,
                        'pickupDate': widget.pickupTime.toLocal().toString(),
                        'pickupTime': widget.pickupTime.toLocal().toString(),
                        'returnDate': widget.returnTime.toLocal().toString(),
                        'returnTime': widget.returnTime.toLocal().toString(),
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotifyMe(
                            vinCar: widget.vin,
                            pickupDateTime: widget.pickupTime.toLocal(),
                            returnDateTime: widget.returnTime.toLocal(),
                          ),
                        ),
                      );
                    }
                  },
                  label: widget.isFree ? "MAKE A RESERVATION" : "NOTIFY ME",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
