import 'package:apuntes/provider/location_provider.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationStatus> checkPermission() async {
    final LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return LocationStatus.accepted;
    }

    return LocationStatus.denied;
  }

  Future<void> requestPermission() async {
    await Geolocator.requestPermission();
  }

  Stream<Position> getLocation() async* {
    final locationSettings = _getAndroidSettins();
    yield* Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  LocationSettings _getAndroidSettins() {
    return AndroidSettings(intervalDuration: const Duration(seconds: 10));
  }
}
