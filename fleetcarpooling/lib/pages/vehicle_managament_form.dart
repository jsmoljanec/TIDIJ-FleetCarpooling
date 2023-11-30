import 'package:fleetcarpooling/Modularity/pages/add_vehicle_form.dart';
import 'package:fleetcarpooling/pages/delete_disable_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class VehicleManagamentForm extends StatelessWidget {
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
            Text("Vehicle managament",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          MyElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVehicleForm()),
                );
              },
              label: 'Add car manually od with QR'),
          MyElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteDisableForm()),
                );
              },
              label: 'Delete/disable car'),
          Expanded(
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
