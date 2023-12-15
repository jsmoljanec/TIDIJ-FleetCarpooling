import 'package:fleetcarpooling/pages/delete_disable_form.dart';
import 'package:fleetcarpooling/pages/user_registration_form.dart';
import 'package:fleetcarpooling/pages/vehicle_managament_form.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                "FLEET CARPOOLING",
                style: TextStyle(
                  color: AppColors.mainTextColor,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserRegistrationForm(),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.buttonColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              minimumSize: MaterialStateProperty.all(const Size(350, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            child: const Text('ADD NEW USER'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleManagamentForm(),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.buttonColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              minimumSize: MaterialStateProperty.all(const Size(350, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            child: const Text('ADD NEW CAR'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteDisableForm(),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.buttonColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              minimumSize: MaterialStateProperty.all(const Size(350, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            child: const Text('LIST ALL CARS'),
          ),
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

