import 'package:core/vehicle.dart';

abstract class VehicleEvent {}

class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;

  AddVehicleEvent({required this.vehicle});
}
