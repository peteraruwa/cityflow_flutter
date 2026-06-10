import 'package:flutter_riverpod/flutter_riverpod.dart';

final rideControllerProvider =
    StateNotifierProvider<RideController, RideState>((ref) {
  return RideController();
});

class RideState {
  const RideState({
    this.pickup = '',
    this.dropoff = '',
    this.selectedVehicleType = 'Keke Napep',
  });

  final String pickup;
  final String dropoff;
  final String selectedVehicleType;

  RideState copyWith({
    String? pickup,
    String? dropoff,
    String? selectedVehicleType,
  }) {
    return RideState(
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
    );
  }
}

class RideController extends StateNotifier<RideState> {
  RideController() : super(const RideState());

  void setPickup(String value) {
    state = state.copyWith(pickup: value);
  }

  void setDropoff(String value) {
    state = state.copyWith(dropoff: value);
  }

  void setVehicleType(String value) {
    state = state.copyWith(selectedVehicleType: value);
  }
}
