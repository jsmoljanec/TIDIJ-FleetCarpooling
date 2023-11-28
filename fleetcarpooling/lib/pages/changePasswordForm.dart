import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<StatefulWidget> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Current password",
                  style: TextStyle(color: AppColors.mainTextColor),
                ),
              ),
            ),
            MyTextField(
              controller: _currentPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "New password",
                  style: TextStyle(color: AppColors.mainTextColor),
                ),
              ),
            ),
            MyTextField(
              controller: _newPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirm password",
                  style: TextStyle(color: AppColors.mainTextColor),
                ),
              ),
            ),
            MyTextField(
              controller: _confirmPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            MyElevatedButton(
              onPressed: () {},
              label: 'Change password',
            ),
          ],
        ),
      ),
    );
  }
}
