import 'package:fleetcarpooling/auth/auth_notify_me.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class NotifyMe extends StatelessWidget {
  final String vinCar;
  final DateTime pickupDateTime;
  final DateTime returnDateTime;

  NotifyMe({
    required this.vinCar,
    required this.pickupDateTime,
    required this.returnDateTime,
  });

  String get pickupDate =>
      "${pickupDateTime.year}-${pickupDateTime.month}-${pickupDateTime.day}";
  String get pickupTime => "${pickupDateTime.hour}:${pickupDateTime.minute}";

  String get returnDate =>
      "${returnDateTime.year}-${returnDateTime.month}-${returnDateTime.day}";
  String get returnTime => "${returnDateTime.hour}:${returnDateTime.minute}";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    AuthNotifyMe authNotifyMe = AuthNotifyMe();

    Future<void> saveNotifyMeData() async {
      print('VIN broj u NotifyMe prije spremanja: $vinCar');
      await authNotifyMe.saveNotifyMeData(
        vinCar,
        pickupDate,
        pickupTime,
        returnDate,
        returnTime,
      );
      print('VIN broj u NotifyMe nakon spremanja: $vinCar');
    }

    // Automatsko spremanje podataka prilikom izgradnje ekrana
    saveNotifyMeData();

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: AppColors.backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: screenHeight * 0.2,
                child: Container(
                  height: 105,
                  width: 129,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/check_mark.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'YOU TURNED NOTIFICATIONS ON! WE WILL NOTIFY YOU AS SOON AS CAR IS AVAILABLE FOR YOUR DATE!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mainTextColor,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
