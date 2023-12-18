class Vehicle {
  String vin;
  String model;
  String brand;
  int capacity;
  String transType;
  int fuelConsumption;
  String registration;
  int year;
  bool active;
  String imageUrl;
  int distanceTraveled;

  Vehicle(
      {required this.vin,
      required this.model,
      required this.brand,
      required this.capacity,
      required this.transType,
      required this.fuelConsumption,
      required this.registration,
      required this.year,
      required this.active,
      required this.imageUrl,
      this.distanceTraveled = 0});

  Map<String, dynamic> toMap() {
    return {
      'vin': vin,
      'model': model,
      'brand': brand,
      'capacity': capacity,
      'transtype': transType,
      'fuelConsumption': fuelConsumption,
      'registration': registration,
      'year': year,
      'active': active,
      'imageUrl': imageUrl,
      'distanceTraveled': distanceTraveled,
    };
  }
}
