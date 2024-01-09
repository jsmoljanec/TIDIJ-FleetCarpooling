import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class AllReservations extends StatefulWidget {
  @override
  State<AllReservations> createState() => _AllReservationsState();
}

class _AllReservationsState extends State<AllReservations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double padding1 = screenHeight * 0.02;
    double padding2 = screenHeight * 0.03;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
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
            Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.buttonColor),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: padding2, bottom: padding1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 51.34, 
                          height: 49.51,
                          child: CircularIconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              'assets/icons/profile.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
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
}
