import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/pages/reset_password_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/pages/navigation.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool logged;
    bool adminIsLogged;
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
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email or Username",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  ),
                ),
                const SizedBox(height: 3.0),
                MyTextField(controller: emailController),
                const SizedBox(height: 15.0),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  ),
                ),
                MyTextField(
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 3.0),
                MyElevatedButton(
                  onPressed: () async {
                    logged = await AuthLogin().login(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    if (logged == true) {
                      adminIsLogged = await AuthLogin().isAdmin();
                      if (adminIsLogged == true) {
                        //implementirati zaslon za admina
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavigationPage()),
                        );
                      }
                    }
                  },
                  label: "Login",
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPasswordForm();
                    }));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
