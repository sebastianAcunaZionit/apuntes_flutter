import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:apuntes/services/services.dart';

part 'location_provider.g.dart';

@riverpod
class LocationProv extends _$LocationProv {
  LocationService locationService = LocationService();

  @override
  LocationState build() {
    return LocationState();
  }

  void onRequestPermissions() async {
    await locationService.requestPermission();
  }

  onLocationService() async {
    final position = await locationService.getLocation();

    state = state.copyWith(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
    );
  }

  void onCheckStatus() async {
    state = state.copyWith(locationStatus: LocationStatus.requesting);
    if (!await locationService.isLocationEnabled()) {
      state = state.copyWith(locationStatus: LocationStatus.denied);
      return;
    }

    LocationStatus status = await locationService.checkPermission();

    if (status == LocationStatus.denied) {
      status = await locationService.requestPermission();
    }
    state = state.copyWith(locationStatus: status);
  }
}

enum LocationStatus { accepted, denied, requesting, forbidden, none }

class LocationState {
  final LocationStatus locationStatus;
  final String longitude;
  final String latitude;
  final String address;

  LocationState({
    this.locationStatus = LocationStatus.none,
    this.longitude = "",
    this.latitude = "",
    this.address = "",
  });

  LocationState copyWith({
    LocationStatus? locationStatus,
    String? longitude,
    String? latitude,
    String? address,
  }) =>
      LocationState(
        locationStatus: locationStatus ?? this.locationStatus,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        address: address ?? this.address,
      );
}
