import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/provider/providers.dart';

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

  Future<LocationStatus> requestPermission() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return LocationStatus.accepted;
    }

    return LocationStatus.denied;
  }

  Future<Position> getLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return position;
    } on TimeoutException catch (e) {
      throw CustomError("no se pudo obtener la locacion ${e.message}");
    } catch (e) {
      throw CustomError("error no controlado");
    }
  }
}
