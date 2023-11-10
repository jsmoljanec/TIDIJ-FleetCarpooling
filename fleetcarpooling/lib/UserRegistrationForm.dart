import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:flutter/material.dart';

class UserRegistrationForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.mainTextColor),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Text(""),
            Text("ADD NEW USER",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  )),
              const SizedBox(height: 3.0),
              MyTextField(controller: emailController),
              const SizedBox(height: 15.0),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "First name",
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              MyTextField(controller: firstNameController),
              const SizedBox(height: 15.0),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Last name",
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              MyTextField(controller: lastNameController),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
