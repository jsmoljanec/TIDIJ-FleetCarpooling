import 'package:flutter/material.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  List<StatefulWidget> pages = [
    const MyReservationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'icons/home_active.png',
                    height: 28,
                    width: 33,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'icons/notification.png',
                    height: 27.5,
                    width: 24,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'icons/map.png',
                    height: 33,
                    width: 27,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'icons/key.png',
                    height: 25,
                    width: 24,
                  ))
            ],
          ),
        ));
  }
}
