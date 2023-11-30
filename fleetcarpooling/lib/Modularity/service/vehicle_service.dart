import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/Modularity/event/vehicle_event.dart';
import 'package:fleetcarpooling/Modularity/models/vehicle.dart';

abstract class VehicleRepository {
  Future<void> addVehicle(AddVehicleEvent event);
}

class VehicleService implements VehicleRepository {
  Future<void> addVehicle(AddVehicleEvent event) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    DatabaseReference carsRef = databaseReference.child("Vehicles");
    DatabaseReference newCarRef = carsRef.child(event.vehicle.vin);
    Vehicle vehicle = new Vehicle(
        vin: event.vehicle.vin,
        model: event.vehicle.model,
        brand: event.vehicle.brand,
        capacity: event.vehicle.capacity,
        transType: event.vehicle.transType,
        fuelConsumption: event.vehicle.fuelConsumption,
        registration: event.vehicle.registration,
        year: event.vehicle.year,
        active: event.vehicle.active,
        imageUrl: event.vehicle.imageUrl);

    newCarRef.set(vehicle.toMap());
  }
}