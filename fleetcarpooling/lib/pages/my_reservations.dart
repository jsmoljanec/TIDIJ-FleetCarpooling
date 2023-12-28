import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/colors';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;

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
          Container(
            height: 50,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.buttonColor))),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "MY RESERVATIONS",
                style: TextStyle(color: AppColors.mainTextColor, fontSize: 24),
              ),
            ),
          )
        ],
      ),
    ));

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.only(bottom: 27.5),
    //         width: screenWidth,
    //         decoration: const BoxDecoration(
    //           border: Border(bottom: BorderSide(color: AppColors.buttonColor)),
    //         ),
    //         child: Padding(
    //           padding: EdgeInsets.only(top: padding2, bottom: padding2),
    //           child: const Text(
    //             "MY RESERVATIONS",
    //             textAlign: TextAlign.center,
    //             style: TextStyle(color: AppColors.mainTextColor, fontSize: 24),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
