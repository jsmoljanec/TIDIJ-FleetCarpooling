import 'dart:async';
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
        distanceTraveled: value['distanceTraveled'],
        latitude: value['latitude'],
        longitude: value['longitude'],
        locked: value['locked'],
      ));
    });

    controller.add(allVehicles);
  });

  return controller.stream;
}

Stream<Vehicle?> getVehicle(String vin) {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vehicles");
  final StreamController<Vehicle?> controller = StreamController<Vehicle?>();

  ref.onValue.listen((DatabaseEvent event) {
    Map<dynamic, dynamic>? values =
        event.snapshot.value as Map<dynamic, dynamic>?;
    Vehicle? vehicle;

    values?.forEach((key, value) {
      if (value['vin'] == vin) {
        vehicle = Vehicle(
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
            latitude: value['latitude'],
            longitude: value['longitude'],
            distanceTraveled: value['distanceTraveled'],
            locked: value['locked']);
      }
    });

    controller.add(vehicle);
  });

  return controller.stream;
}

Future<String?> getVehicleModelAndBrand(String vin) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vehicles");

  String? vehicleModelAndBrand;

  try {
    DatabaseEvent event = await ref.orderByChild('vin').equalTo(vin).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        if (value['vin'] == vin) {
          String model = value['model'];
          String brand = value['brand'];
          vehicleModelAndBrand = '$brand $model';
        }
      });
    }
  } catch (e) {
    print('Error getting vehicle data: $e');
    return null;
  }

  return vehicleModelAndBrand;
}

Future<void> disableCar(String vin, bool active) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vehicles/${vin}");

  await ref.update({
    if (active == true) "active": false,
    if (active == false) "active": true,
  });
}

Future<void> deleteCar(String vin) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vehicles/${vin}");

  await ref.remove();
}

Stream<bool> getLockStateStream(String vinCar) {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref("Vehicles/$vinCar/locked");
  final StreamController<bool> controller = StreamController<bool>();

  ref.onValue.listen((DatabaseEvent event) {
    bool isLocked = event.snapshot.value == true ? true : false;
    controller.add(isLocked);
  });

  return controller.stream;
}

Future<Vehicle?> getVehicleByVin(String vin) async {
  final databaseReference = FirebaseDatabase.instance.ref();
  var query = await databaseReference
      .child("Vehicles")
      .orderByChild('vin')
      .equalTo(vin)
      .limitToFirst(1);

  DatabaseEvent event = await query.once();
  Map<dynamic, dynamic>? values =
      event.snapshot.value as Map<dynamic, dynamic>?;
  Vehicle? vehicle;
  values?.forEach((key, value) {
    vehicle = Vehicle(
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
        latitude: value['latitude'],
        longitude: value['longitude'],
        distanceTraveled: value['distanceTraveled'],
        locked: value['locked']);
  });
  return vehicle;
}
