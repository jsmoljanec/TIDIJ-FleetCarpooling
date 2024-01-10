import 'package:core/add_vehicle_interface.dart';
import 'package:core/bloc/vehicle_bloc.dart';
import 'package:core/ui_elements/buttons.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manuallyaddition/add_vehicle_manually_form.dart';
import 'package:qraddition/add_vehicle_QR_form.dart';

class AddVehicleSelection extends StatelessWidget {
  final List<AddVehicleInteface> _vehicleAdditionForms = [
    AddVehicleManuallyForm() as AddVehicleInteface,
    AddVehicleQRForm() as AddVehicleInteface
  ];

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
            Text("ADD NEW CAR",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._vehicleAdditionForms.map(
              (vehicleAdditionForm) => MyElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => VehicleBloc(),
                        child: vehicleAdditionForm,
                      ),
                    ),
                  );
                },
                label: vehicleAdditionForm.getName(),
              ),
            ),
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
