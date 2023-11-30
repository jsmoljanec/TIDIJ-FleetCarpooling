import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';

Stream<List<Vehicle>> getVehicles() {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vehicles");
  final StreamController<List<Vehicle>> controller =
      StreamController<List<Vehicle>>();
  ref.onValue.listen((DatabaseEvent event) {
    List<Vehicle> allVehicles = [];

    Map<dynamic, dynamic>? values =
        event.snapshot.value as Map<dynamic, dynamic>?;
    values?.forEach((key, value) {
      allVehicles.add(Vehicle(
        vin: value['vin'],
        model: value['model'],
        brand: value['brand'],
        capacity: value['capacity'],
        transType: value['transtype'],
        fuelConsumption: value['fuelConsumption'],
        registration: value['registration'],
        year: value['year'],
        active: value['active'],
        imageUrl: value['imageUrl'],
      ));
    });

    controller.add(allVehicles);
  });

  return controller.stream;
}

Future<void> disableCar(String vin, bool active) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vehicles/${vin}");

  await ref.update({
    if (active == true) "active": false,
    if (active == false) "active": true,
  });
}
