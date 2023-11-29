import 'dart:convert';

import 'package:fleetcarpooling/Modularity/bloc/vehicle_bloc.dart';
import 'package:fleetcarpooling/Modularity/event/vehicle_event.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddVehicleQRForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddVehicleQRForm();
}

class _AddVehicleQRForm extends State<AddVehicleQRForm> {
  late final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String qrText = '';
  bool isCameraPaused = false;

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
                    TextStyle(color: AppColors.mainTextColor, fontSize: 18.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      handleScannedData(scanData.code!);
    });
  }

  void handleScannedData(String scannedData) {
    print("skenirano");
    Map<String, dynamic> decodedData = jsonDecode(scannedData);
    String vin = decodedData['vin'];
    String model = decodedData['model'];
    String brand = decodedData['brand'];
    int capacity = int.parse(decodedData['capacity']);
    String trans = decodedData['transType'];
    int fuel = int.parse(decodedData['fuelConsumption']);
    String registration = decodedData['registration'];
    int year = int.parse(decodedData['year']);
    String imageUrl = decodedData['imageUrl'];
    bool active = true;

    Vehicle newVehicle = Vehicle(
        vin: vin,
        model: model,
        brand: brand,
        capacity: capacity,
        transType: trans,
        fuelConsumption: fuel,
        registration: registration,
        year: year,
        active: active,
        imageUrl: imageUrl);

    BlocProvider.of<VehicleBloc>(context)
        .add(AddVehicleEvent(vehicle: newVehicle));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
