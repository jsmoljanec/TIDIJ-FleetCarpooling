import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/pages/map.dart';
import 'package:fleetcarpooling/pages/my_reservations.dart';
import 'package:fleetcarpooling/pages/notification_page.dart';
import 'package:fleetcarpooling/pages/home_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int pressed = 0;
  List<StatefulWidget> pages = [
    const HomePage(),
    const NotificationPage(),
    const MapPage(),
    const MyReservationsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[pressed],
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          height: 40,
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.buttonColor))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 0;
                    });
                  },
                  icon: pressed == 0
                      ? Image.asset(
                          'icons/home_active.png',
                          height: 28,
                          width: 33,
                        )
                      : Image.asset(
                          'icons/home.png',
                          height: 28,
                          width: 33,
                        )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 1;
                    });
                  },
                  icon: pressed == 1
                      ? Image.asset(
                          'icons/notification_active.png',
                          height: 27.5,
                          width: 24,
                        )
                      : Image.asset(
                          'icons/notification.png',
                          height: 27.5,
                          width: 24,
                        )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 2;
                    });
                  },
                  icon: pressed == 2
                      ? Image.asset(
                          'icons/map_active.png',
                          height: 33,
                          width: 27,
                        )
                      : Image.asset(
                          'icons/map.png',
                          height: 33,
                          width: 27,
                        )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 3;
                    });
                  },
                  icon: pressed == 3
                      ? Image.asset(
                          'icons/key_active.png',
                          height: 25,
                          width: 24,
                        )
                      : Image.asset(
                          'icons/key.png',
                          height: 25,
                          width: 24,
                        ))
            ],
          ),
        ));
  }
}
