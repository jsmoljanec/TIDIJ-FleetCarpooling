import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/colors';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          height: 40,
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.buttonColor))),
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
