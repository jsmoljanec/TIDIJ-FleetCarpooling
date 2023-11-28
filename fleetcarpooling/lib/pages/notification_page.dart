import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/colors';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;
    return  Scaffold(
      body:  Column(
          children: [
            Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.buttonColor))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: padding2, bottom: padding2),
                child: const Text("NOTIFICATIONS",textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mainTextColor,fontSize: 24,),
                ),
              )
            )
          ],
        ),
    );
  }
}
