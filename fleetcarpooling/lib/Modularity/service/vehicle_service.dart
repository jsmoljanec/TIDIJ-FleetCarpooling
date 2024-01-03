import 'package:core/event/vehicle_event.dart';
import 'package:core/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class VehicleRepository {
  Future<void> addVehicle(AddVehicleEvent event);
}

class VehicleService implements VehicleRepository {
  @override
  Future<void> addVehicle(AddVehicleEvent event) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    DatabaseReference carsRef = databaseReference.child("Vehicles");
    DatabaseReference newCarRef = carsRef.child(event.vehicle.vin);
    Vehicle vehicle = Vehicle(
        vin: event.vehicle.vin,
        model: event.vehicle.model,
        brand: event.vehicle.brand,
        capacity: event.vehicle.capacity,
        transType: event.vehicle.transType,
        fuelConsumption: event.vehicle.fuelConsumption,
        registration: event.vehicle.registration,
        year: event.vehicle.year,
        active: event.vehicle.active,
        imageUrl: event.vehicle.imageUrl,
        distanceTraveled: event.vehicle.distanceTraveled,
        latitude: event.vehicle.latitude,
        longitude: event.vehicle.longitude,
        locked: event.vehicle.locked,
        token: {"1": "1"});

    newCarRef.set(vehicle.toMap());
  }
}
