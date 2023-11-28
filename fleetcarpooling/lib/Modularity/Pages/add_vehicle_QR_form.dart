import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
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
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
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
      if (!isCameraPaused) {
        setState(() {
          qrText = scanData.code!;
          isCameraPaused = true;
        });
      }
    });
  }
}
