import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class NotifyMe extends StatelessWidget {
  const NotifyMe({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
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
    );
  }
}
