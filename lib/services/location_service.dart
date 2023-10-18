import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  Future<String> getAddress(Position position) async {
    final address = await _getAddressFromCoordinates(position);
    return address;
  }

  Future<String> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return "Dirección no encontrada";
      }

      Placemark placemark = placemarks[0];
      String formattedAddress =
          "${placemark.street}, ${placemark.locality}, ${placemark.country}";
      return formattedAddress;
    } catch (e) {
      return "Sin internet para obtener dirección";
      // return "Error al obtener la dirección: $e";
    }
  }
}
