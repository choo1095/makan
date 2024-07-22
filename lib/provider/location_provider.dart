import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:makan/types/result.dart';

final locationProvider = ChangeNotifierProvider((ref) => LocationProvider());

class LocationProvider extends ChangeNotifier {
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;

  LocationData? get locationData => _locationData;

  Future<bool> getLocationPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception(
            'Location service not enabled. Please enable location settings.');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception(
            'Location permissions not granted. Please enable location settings in Settings > Apps > Makan > Location..');
      }
    }

    return true;
  }

  Future<Result<LocationData, String>> getLocation() async {
    try {
      final hasPermissions = await getLocationPermissions();

      if (hasPermissions) {
        _locationData = await location.getLocation();
      }

      return Success(_locationData!);
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
