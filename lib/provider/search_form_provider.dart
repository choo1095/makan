import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:makan/api/rest_client.dart';
import 'package:makan/constants/places.dart';
import 'package:makan/env/env.dart';
import 'package:makan/types/nearby_places_params.dart';

enum SearchRadius {
  focused,
  expanded,
}

final searchFormProvider =
    ChangeNotifierProvider((ref) => SearchFormProvider());

class SearchFormProvider extends ChangeNotifier {
  bool _isLoading = false;

  String _locationSearchQuery = '';
  SearchRadius _radius = SearchRadius.expanded;
  (double lat, double lon) _location = (0.0, 0.0);
  int _minPrice = 0;
  int _maxPrice = 4;
  List<String> _foodTypes = [];

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
  bool get hasLocation => _location != (0.0, 0.0);
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

  List<String> get foodTypes => _foodTypes;
  bool get maxFoodTypesSelected => _foodTypes.length >= 5;
  set foodTypes(List<String> value) {
    _foodTypes = value;

    notifyListeners();
  }

  Future<void> fetchLatLonFromGeocoder() async {
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

  void resetForm() {
    _locationSearchQuery = '';
    _radius = SearchRadius.expanded;
    _location = (0.0, 0.0);
    _minPrice = 0;
    _maxPrice = 4;

    notifyListeners();
  }
}
