import 'package:core/services/vehicle_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/pages/delete_disable_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

void main() {
  FirebaseDatabase firebaseDatabase;
  VehicleService? vehicleService;
  const fakeData = {
    'Vehicles': {
      'vehicle1': {
        'vin': 'ABC123',
        'model': 'Model1',
        'brand': 'Brand1',
        'capacity': 5,
        'transType': 'manual',
        'fuelConsumption': 3,
        'registration': 'asdasd',
        'year': 2015,
        'active': true,
        'imageUrl': "asdasdasd",
        'latitude': 46.3897,
        'longitude': 16.4380,
        'locked': true
      },
      'vehicle2': {
        'vin': 'DEF456',
        'model': 'Model2',
        'brand': 'Brand2',
        'capacity': 5,
        'transType': 'manual',
        'fuelConsumption': 3,
        'registration': 'asdasd',
        'year': 2015,
        'active': true,
        'imageUrl': "asdasdasd",
        'latitude': 46.3897,
        'longitude': 16.4380,
        'locked': true
      },
    },
  };
  MockFirebaseDatabase.instance.ref().set(fakeData);
  firebaseDatabase = MockFirebaseDatabase.instance;

  setUp(() {
    vehicleService = VehicleService(firebaseDatabase);
  });
  group("VehicleManagement", () {
    test('Should update car in active', () async {
      await disableCar("vehicle1", false, firebaseDatabase);
      DatabaseEvent snapshot = await firebaseDatabase
          .ref()
          .child('Vehicles')
          .child('vehicle1')
          .once();

      Map<dynamic, dynamic> values =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      expect(values['active'], true);
    });

    test('Should deactivated car', () async {
      await disableCar("vehicle1", true, firebaseDatabase);
      DatabaseEvent snapshot = await firebaseDatabase
          .ref()
          .child('Vehicles')
          .child('vehicle1')
          .once();

      Map<dynamic, dynamic> values =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      expect(values['active'], false);
    });
  });
}
