import 'package:fleetcarpooling/Modularity/Pages/add_vehicle_QR_form.dart';
import 'package:fleetcarpooling/Modularity/Pages/add_vehicle_manually_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class AddVehicleForm extends StatelessWidget {
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
            Text("ADD NEW CAR",
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
                  MaterialPageRoute(
                      builder: (context) => AddVehicleManuallyForm()),
                );
              },
              label: 'Add vehicle manually'),
          MyElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVehicleQRForm()),
                );
              },
              label: 'Add vehicle with QR code'),
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
