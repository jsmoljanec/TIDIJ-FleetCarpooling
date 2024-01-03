import 'package:core/add_vehicle_selection.dart';
import 'package:fleetcarpooling/pages/all_reservations.dart';
import 'package:fleetcarpooling/pages/all_users_form.dart';
import 'package:fleetcarpooling/pages/delete_disable_form.dart';
import 'package:fleetcarpooling/pages/profile_form.dart';
import 'package:fleetcarpooling/pages/user_registration_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "FLEET CARPOOLING",
              style: TextStyle(color: AppColors.mainTextColor, fontSize: 30.0),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              child: Image.asset(
                'assets/icons/profile.png',
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              MyElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserRegistrationForm(),
                    ),
                  );
                },
                label: 'ADD NEW USER',
              ),
              MyElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddVehicleSelection(),
                    ),
                  );
                },
                label: 'ADD NEW CAR',
              ),
              MyElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteDisableForm(),
                    ),
                  );
                },
                label: 'LIST ALL CARS',
              ),
              MyElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllUsersForm(),
                    ),
                  );
                },
                label: 'LIST ALL USERS',
              ),
              MyElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllReservations(),
                    ),
                  );
                },
                label: 'LIST ALL RESERVATIONS',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
