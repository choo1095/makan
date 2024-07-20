import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:makan/api/rest_client.dart';
import 'package:makan/constants/places.dart';
import 'package:makan/env/env.dart';
import 'package:makan/provider/location_provider.dart';

enum SearchRadius {
  focused,
  expanded,
}

final searchFormProvider =
    ChangeNotifierProvider((ref) => SearchFormProvider());

class SearchFormProvider extends ChangeNotifier {
  late String _locationSearchQuery = '';
  late SearchRadius _radius = SearchRadius.expanded;
  late (double lat, double lon) _location = (0.0, 0.0);
  late int _minPrice = 0;
  late int _maxPrice = 4;

  String get locationSearchQuery => _locationSearchQuery;
  set locationSearchQuery(String value) {
    // set location search query
    _locationSearchQuery = value;

    // update search radius
    if (value.isNotEmpty) {
      _radius = SearchRadius.focused;
    } else {
      _radius = SearchRadius.expanded;
    }

    notifyListeners();
  }

  SearchRadius get radius => _radius;
  // set radius(SearchRadius value) {
  //   _radius = value;
  //   notifyListeners();
  // }

  (double lat, double lon) get location => _location;
  bool get isLocationEmpty => _location == (0.0, 0.0);
  set location((double lat, double lon) value) {
    _location = value;

    notifyListeners();
  }

  int get minPrice => _minPrice;
  set minPrice(int value) {
    _minPrice = value;

    notifyListeners();
  }

  int get maxPrice => _maxPrice;
  set maxPrice(int value) {
    _maxPrice = value;

    notifyListeners();
  }

  void fetchLatLonFromGeocoder() async {
    final res = await client()
        .getGeocode(key: Env.googleMapsApiKey, address: _locationSearchQuery);

    if (res.status == STATUS_OK) {
      final geometry = res.results?.firstOrNull?.geometry;
      _location =
          (geometry?.location?.lat ?? 0.0, geometry?.location?.lng ?? 0.0);
    } else {
      print('location not found');
    }
  }

  void setLatLonFromDevice(LocationData? deviceCoordinates) {
    if (deviceCoordinates != null) {
      _location = (
        deviceCoordinates.latitude ?? 0.0,
        deviceCoordinates.longitude ?? 0.0
      );
    } else {
      print('no location data');
    }
  }

  Map<String, dynamic> convertToApiParams() {
    return {
      'key': Env.googleMapsApiKey,
      'location': '${_location.$1},${_location.$2}',
      'radius': _radius == SearchRadius.focused ? 1500 : 20000,
      'min_price': _minPrice,
      'max_price': _maxPrice,
      'type': 'restaurant',
    };
  }

  void resetForm() {
    _locationSearchQuery = '';
    _radius = SearchRadius.expanded;
    _location = (0.0, 0.0);
    _minPrice = 0;
    _maxPrice = 4;

    notifyListeners();
  }
}
