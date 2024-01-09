import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/pages/my_reservations.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/Models/reservation_model.dart';
import 'package:fleetcarpooling/ReservationService/reservation_service.dart';

class AllReservations extends StatefulWidget {
  const AllReservations({Key? key}) : super(key: key);

  @override
  State<AllReservations> createState() => _AllReservationsState();
}

class _AllReservationsState extends State<AllReservations> {
  late final ReservationService _service = ReservationService();
  late Stream<List<Reservation>> _reservationsStream;

  @override
  Widget build(BuildContext context) {
    _reservationsStream = _service.getAllReservations();

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 450),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.buttonColor),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 51.34,
                                height: 49.51,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: CircularIconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Here you can manage",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.mainTextColor,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    "all reservations",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.mainTextColor,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/icons/profile.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<List<Reservation>>(
                        stream: _reservationsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                  
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No reservations.'));
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
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshotInfo.data ??
                                                  "Could not fetch car information",
                                              style: const TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 24,
                                                bottom: 12,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${getShortWeekday(snapshot.data![index].pickupDate)}, ${snapshot.data![index].pickupDate.day}. ${snapshot.data![index].pickupDate.month}",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .mainTextColor,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward,
                                                        color: AppColors
                                                            .mainTextColor,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        "${getShortWeekday(snapshot.data![index].returnDate)}, ${snapshot.data![index].returnDate.day}. ${snapshot.data![index].returnDate.month}",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .mainTextColor,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "${(snapshot.data![index].name)}",
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .mainTextColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 0.5,
                                              color: AppColors.mainTextColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                bottom: 24,
                                              ),
                                              child: InkWell(
                                                child: const Text(
                                                  "Cancel reservation",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.mainTextColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                onTap: () {
                                                  DateTime currentDate =
                                                      DateTime.now();
                                                  if (snapshot
                                                      .data![index].pickupDate
                                                      .isAfter(currentDate)) {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return Center(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .backgroundColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                              80,
                                                                              28,
                                                                              80,
                                                                              28),
                                                                  child: Text(
                                                                    'ARE YOU SURE?',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .mainTextColor,
                                                                      fontSize:
                                                                          24,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  height: 0.5,
                                                                  color: AppColors
                                                                      .mainTextColor,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                        CustomToast()
                                                                            .showFlutterToast(
                                                                                "You successfully canceled the reservation");
                                                                      },
                                                                      child:
                                                                          const Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                20,
                                                                            bottom:
                                                                                20),
                                                                        child:
                                                                            Text(
                                                                          'YES',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.mainTextColor,
                                                                            fontSize:
                                                                                24,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 70,
                                                                      width: 0.5,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                AppColors.mainTextColor),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                20,
                                                                            bottom:
                                                                                20),
                                                                        child:
                                                                            Text(
                                                                          'NO',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.mainTextColor,
                                                                            fontSize:
                                                                                24,
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
                                                      },
                                                    );
                                                  } else {
                                                    CustomToast().showFlutterToast(
                                                        "Cannot cancel past reservation");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
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
        ],
      ),
    );
  }
}
