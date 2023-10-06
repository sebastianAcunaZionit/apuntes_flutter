import 'package:apuntes/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
class LocationProv extends _$LocationProv {
  LocationService locationService = LocationService();

  @override
  LocationState build() {
    return LocationState();
  }

  void onRequestPermissions() async {
    print('solicitar persmiso');
    await locationService.requestPermission();
  }

  void onCheckStatus() async {
    if (!await locationService.isLocationEnabled()) {
      state = state.copyWith(locationStatus: LocationStatus.denied);
      return;
    }

    final status = await locationService.checkPermission();

    if (status == LocationStatus.denied) {
      locationService.requestPermission();
    }
    state = state.copyWith(locationStatus: status);
  }
}

enum LocationStatus { accepted, denied, forbidden, none }

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
