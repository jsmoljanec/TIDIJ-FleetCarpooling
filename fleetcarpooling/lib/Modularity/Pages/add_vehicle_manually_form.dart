import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddVehicleManuallyForm extends StatefulWidget {
  @override
  _AddVehicleManuallyForm createState() => _AddVehicleManuallyForm();
}

class _AddVehicleManuallyForm extends State<AddVehicleManuallyForm> {
  final TextEditingController vinController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.mainTextColor),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Text("ADD NEW CAR MANUALLY",
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
          const SizedBox(height: 50),
          const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "VIN",
                  style: TextStyle(color: AppColors.mainTextColor),
                ),
              )),
          const SizedBox(height: 3.0),
          MyTextField(controller: vinController),
          const SizedBox(height: 10),
          const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Model",
                  style: TextStyle(color: AppColors.mainTextColor),
                ),
              )),
          const SizedBox(height: 3.0),
          MyTextField(controller: modelController),
          const SizedBox(height: 10),
          const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Brand",
                  style: TextStyle(color: AppColors.mainTextColor),
                ),
              )),
          const SizedBox(height: 3.0),
          MyTextField(controller: brandController),
        ],
      ),
    );
  }
}
