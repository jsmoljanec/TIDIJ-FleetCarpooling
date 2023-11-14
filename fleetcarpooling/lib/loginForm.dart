import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: 180,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Fleet Carpooling",
                  style:
                      TextStyle(color: AppColors.mainTextColor, fontSize: 25.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "SIGN IN TO CONTINUE",
                  style:
                      TextStyle(color: AppColors.mainTextColor, fontSize: 25.0),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
