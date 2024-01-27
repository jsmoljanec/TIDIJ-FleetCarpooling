
import 'package:fleetcarpooling/utils/datetime_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

void main() {

  const fakeDataVehicle = {
    'Vehicles': {
      '12345678': {
        'vin': '1HGCM82633A123456',
        'model': 'Model S',
        'brand': 'Tesla',
        'capacity': 5,
        'transtype': 'Automatic',
        'fuelConsumption': 10,
        'registration': '2022-01-01',
        'year': 2022,
        'active': true,
        'imageUrl': 'https://example.com/image.jpg',
        'distanceTraveled': 1000,
        'latitude': 37.7749,
        'longitude': 122.4194,
        'locked': false,
      },
      '11223344': {
        'vin': '1HGCM82788A123456',
        'model': 'M1',
        'brand': 'B1',
        'capacity': 5,
        'transtype': 'Automatic',
        'fuelConsumption': 10,
        'registration': '2022-01-01',
        'year': 2022,
        'active': true,
        'imageUrl': 'https://example.com/image.jpg',
        'distanceTraveled': 1000,
        'latitude': 37.7749,
        'longitude': 122.4194,
        'locked': false,
      }
    }
  };
  FirebaseDatabase firebaseDatabaseVehicle = MockFirebaseDatabase.instance;

setUp(() {
      MockFirebaseDatabase.instance.ref().set(fakeDataVehicle);
    });
    test('getVehicles test', () async {
      final vehiclesStream = getVehicles(firebaseDatabaseVehicle);

      expectLater(vehiclesStream, emits(anyElement(isNotNull)));
    });


  test('getShortWeekday returns correct value for each weekday', () {
    final dateTimeUtils = DateTimeUtils();

    final mondayShortWeekday = dateTimeUtils.getShortWeekday(DateTime(2024, 1, 27));
    expect(mondayShortWeekday, equals('Sat'));

    final tuesdayShortWeekday = dateTimeUtils.getShortWeekday(DateTime(2024, 1, 28));
    expect(tuesdayShortWeekday, equals('Sun'));

    final wednesdayShortWeekday = dateTimeUtils.getShortWeekday(DateTime(2024, 1, 29));
    expect(wednesdayShortWeekday, equals('Mon'));
  });
}