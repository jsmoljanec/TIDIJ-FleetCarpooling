import 'package:bloc/bloc.dart';
import 'package:core/event/vehicle_event.dart';
import 'package:core/state/vehicle_state.dart';
import 'package:fleetcarpooling/Modularity/service/vehicle_service.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository _vehicleRepository;
  VehicleBloc(this._vehicleRepository) : super(VehicleInitialState()) {
    on<AddVehicleEvent>((event, emit) async {
      emit(VehicleLoadingState());

      try {
        await _vehicleRepository.addVehicle(event);
        emit(VehicleLoadedState(successMessage: 'Vehicle is added'));
      } catch (error) {
        emit(VehicleErrorState(errorMessage: 'Failed to add vehicle'));
      }
    });
  }
}
