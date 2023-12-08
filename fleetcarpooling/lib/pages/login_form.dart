import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/pages/reset_password_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/pages/navigation.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool? logged;
  bool? adminIsLogged;
  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                  'assets/images/logo_login.png',
                  width: 320,
                  height: 220,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "FLEET CARPOOLING",
                  style:
                      TextStyle(color: AppColors.mainTextColor, fontSize: 32.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "SIGN IN TO CONTINUE",
                  style:
                      TextStyle(color: AppColors.mainTextColor, fontSize: 24.0),
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
                MyTextField(
                  controller: emailController,
                  backgroundColor: Colors.white,
                ),
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
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 3.0),
                MyElevatedButton(
                  key: UniqueKey(),
                  onPressed: () async {
                    setState(() {
                      logged = null;
                      errorMessage = null;
                      isLoading = true;
                    });

                    logged = await AuthLogin().login(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    setState(() {
                      isLoading = false;
                    });

                    if (logged == true) {
                      adminIsLogged = await AuthLogin().isAdmin();
                      if (adminIsLogged == true) {
                        //implementirati zaslon za admina
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationPage(),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        errorMessage =
                            'Login failed. Please check your credentials.';
                      });
                    }
                  },
                  label: "Login",
                  isLoading: isLoading,
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
                if (logged == false && errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
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
