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
              margin: EdgeInsets.only(bottom: 27.5),
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
            ),
            const Padding(
              padding: EdgeInsets.only(left: 28,right: 29,bottom: 12),
              child: Card(
                  margin: EdgeInsets.only(left: 28,right: 29,bottom: 12),
                    color: AppColors.backgroundColor,
                    child:  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Ovdje ide opis",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                                fontSize: 20
                              ),),
                    ),
                    ),
            )
          ],
        ),
    );
  }
}
