import 'package:core/ui_elements/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/auth/auth_registration_service.dart';

import 'package:core/ui_elements/colors';
import 'package:core/ui_elements/text_field.dart';
import 'package:flutter/material.dart';

enum UserType { Administrator, Employee }

class UserRegistrationForm extends StatefulWidget {
  @override
  _UserRegistrationForm createState() => _UserRegistrationForm();
}

class _UserRegistrationForm extends State<UserRegistrationForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  UserType _selectedUserType = UserType.Employee;
  final AuthRegistrationService _authRegistrationService =
      new AuthRegistrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ADD NEW USER",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(color: AppColors.mainTextColor),
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
                    style: TextStyle(color: AppColors.mainTextColor),
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
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              MyTextField(controller: lastNameController),
              const SizedBox(height: 15.0),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Role",
                    style: TextStyle(
                        color: AppColors.mainTextColor, fontSize: 15.0),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedUserType = UserType.Employee;
                              });
                            },
                            child: MyRadioButton(
                              title: "Employee",
                              onChanged: (value) {
                                setState(() {
                                  _selectedUserType = UserType.Employee;
                                });
                              },
                              value: _selectedUserType == UserType.Employee,
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedUserType = UserType.Administrator;
                              });
                            },
                            child: MyRadioButton(
                              title: "Admin",
                              onChanged: (value) {
                                setState(() {
                                  _selectedUserType = UserType.Administrator;
                                });
                              },
                              value:
                                  _selectedUserType == UserType.Administrator,
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 10),
                child: MyElevatedButton(
                    onPressed: () async {
                      try {
                        await _authRegistrationService.registerUser(
                            emailController.text,
                            firstNameController.text,
                            lastNameController.text,
                            _selectedUserType.name.toString());
                        ScaffoldMessenger.of(context as BuildContext)
                            .showSnackBar(const SnackBar(
                          content: Text('User added and message sent'),
                        ));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context as BuildContext)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('User not added! Email already in use'),
                          ));
                        } else if (e.code == 'wrong-format') {
                          ScaffoldMessenger.of(context as BuildContext)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('User not added! Wrong email format!'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context as BuildContext)
                              .showSnackBar(const SnackBar(
                            content: Text('User not added!'),
                          ));
                        }
                      }
                    },
                    label: "ADD NEW USER"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
