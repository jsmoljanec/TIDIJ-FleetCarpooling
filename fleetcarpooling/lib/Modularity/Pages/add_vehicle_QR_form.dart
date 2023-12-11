import 'dart:convert';

import 'package:fleetcarpooling/Modularity/bloc/vehicle_bloc.dart';
import 'package:fleetcarpooling/Modularity/event/vehicle_event.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/Modularity/state/vehicle_state.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is VehicleErrorState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: AlertDialog(
                title: const Text('Message'),
                content: Text(state.errorMessage),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is VehicleLoadedState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: AlertDialog(
                title: const Text('Message'),
                content: Text(state.successMessage),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return _buildUI(context);
        }
      },
    );
  }

  Widget _buildUI(BuildContext context) {
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
            Text("ADD NEW CAR ",
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
        imageUrl: imageUrl,
        latitude: 0,
        longitude: 0);

    BlocProvider.of<VehicleBloc>(context)
        .add(AddVehicleEvent(vehicle: newVehicle));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
