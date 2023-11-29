import 'package:fleetcarpooling/Modularity/models/vehicle.dart';

abstract class VehicleEvent {}

class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;

  AddVehicleEvent({required this.vehicle});
}
