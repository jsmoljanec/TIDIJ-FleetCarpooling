import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: padding2, bottom: padding2, left: 24, right: 24),
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Thu, 26 Oct",
                                  style: TextStyle(
                                      color: AppColors.mainTextColor,
                                      fontSize: 24),
                                ),
                                Text(
                                  "11:00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      color: AppColors.mainTextColor,
                                      fontSize: 24),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.buttonColor,
                                ),
                                Text(
                                  " ",
                                  style: TextStyle(fontSize: 24),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Fri, 27 Oct",
                                  style: TextStyle(
                                      color: AppColors.mainTextColor,
                                      fontSize: 24),
                                ),
                                Text(
                                  "17:30",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      color: AppColors.mainTextColor,
                                      fontSize: 24),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            child: Image.asset("icons/profile.png"),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
