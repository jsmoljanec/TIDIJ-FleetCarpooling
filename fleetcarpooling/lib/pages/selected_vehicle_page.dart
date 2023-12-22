import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/Models/terms_model.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';
import 'package:fleetcarpooling/ReservationService/terms_service.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/pages/notify_me_page.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class SelectedVehiclePage extends StatefulWidget {
  final String vin;
  final bool isFree;
  final DateTime pickupTime;
  final DateTime returnTime;

  const SelectedVehiclePage(
      {Key? key,
      required this.vin,
      required this.isFree,
      required this.pickupTime,
      required this.returnTime})
      : super(key: key);

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  late ReservationService _service = ReservationService();
  final TermsService _termsService = TermsService();
  late List<Terms> termini;
  late List<DateTime> busyTerms;
  late List<DateTime> freeTerms;

  @override
  void initState() {
    super.initState();
    _service = ReservationService();
    termini = [];
    busyTerms = [];
    freeTerms = [];

    _loadData();
  }

  void _loadData() {
    List<DateTime> workHours = _termsService.createWorkHours(
        DateTime.now(), DateTime.now().add(const Duration(days: 365)));

    _service.getReservationStream(widget.vin).listen((newTermini) {
      termini = newTermini;
      busyTerms = _termsService.extractReservedTerms(termini);

      freeTerms =
          workHours.where((termin) => !busyTerms.contains(termin)).toList();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;
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
                              width: 300,
                              busyTerms: busyTerms,
                              freeTerms: freeTerms,
                            ),
                            InkWell(
                              onTap: () {
                                //vodi na zaslon gdje se bira datum i vrijeme
                              },
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
                            MyElevatedButton(
                              onPressed: () async {
                                if (widget.isFree == true) {
                                  await _service.addReservation(widget.vin,
                                      widget.pickupTime, widget.returnTime);
                                  await _service.confirmRegistration(email,
                                      widget.pickupTime, widget.returnTime);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const NotifyMe()),
                                  );
                                }
                              },
                              label: widget.isFree
                                  ? "MAKE A RESERVATION"
                                  : "NOTIFY ME",
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
