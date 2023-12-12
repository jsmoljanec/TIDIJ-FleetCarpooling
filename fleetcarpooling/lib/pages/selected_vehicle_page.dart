import 'package:flutter/material.dart';

class SelectedVehiclePage extends StatefulWidget {
  final String vin;
  const SelectedVehiclePage({super.key, required this.vin});

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.vin);
  }
}
