import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

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
        log('location service not enabled');
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        log('location permissions not granted');
        return false;
      }
    }

    return true;
  }

  Future<LocationData?> getLocation() async {
    final hasPermissions = await getLocationPermissions();

    if (hasPermissions) {
      _locationData = await location.getLocation();
      log(_locationData.toString());
    }

    return _locationData;
  }
}
