import 'dart:async';
import 'package:core/event/vehicle_event.dart';
import 'package:core/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/Models/vehicle_location_model.dart';

abstract class VehicleLocationRepository {
  Future<void> initializeVehicleLocation(VehicleLocation vehicleLocation);
  Stream<List<VehicleLocation>> getVehicleLocations();
}

class VehicleLocationService implements VehicleLocationRepository {
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Future<void> initializeVehicleLocation(
      VehicleLocation vehicleLocation) async {
    DatabaseReference vehicleLocationRef =
        databaseReference.child("VehicleLocations");
    DatabaseReference newVehicleLocationLocationRef =
        vehicleLocationRef.child(vehicleLocation.vin);
    VehicleLocation newVehicleLocation = VehicleLocation(
      vin: vehicleLocation.vin,
      model: vehicleLocation.model,
      brand: vehicleLocation.brand,
      latitude: vehicleLocation.latitude,
      longitude: vehicleLocation.longitude,
      locked: vehicleLocation.locked,
    );
    newVehicleLocationLocationRef.set(newVehicleLocation.toMap());
  }

  @override
  Stream<List<VehicleLocation>> getVehicleLocations() {
    DatabaseReference ref = databaseReference.child("VehicleLocations");
    final StreamController<List<VehicleLocation>> controller =
        StreamController<List<VehicleLocation>>();
    ref.onValue.listen((DatabaseEvent event) {
      List<VehicleLocation> allVehicleLocations = [];

      Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;
      values?.forEach((key, value) {
        allVehicleLocations.add(VehicleLocation(
          vin: value['vin'],
          model: value['model'],
          brand: value['brand'],
          latitude: value['latitude'],
          longitude: value['longitude'],
          locked: value['locked'],
        ));
      });

      controller.add(allVehicleLocations);
    });
    return controller.stream;
  }

  Future<void> deleteVehicleLocationRecord(String vin) async {
    DatabaseReference ref = databaseReference.child("VehicleLocations/$vin");
    await ref.remove();
  }
}
