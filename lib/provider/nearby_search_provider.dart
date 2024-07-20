import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/api/rest_client.dart';
import 'package:makan/constants/places.dart';
import 'package:makan/env/env.dart';
import 'package:makan/provider/search_form_provider.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/types/nearby_places_params.dart';

final nearbySearchProvider =
    ChangeNotifierProvider((ref) => NearbySearchProvider());

class NearbySearchProvider extends ChangeNotifier {
  bool _isLoading = false;

  NearbySearchData? _nearbySearchParams;

  List<List<GooglePlaces>> _nearbySearchResults = [];

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  NearbySearchData? get nearbySearchParams => _nearbySearchParams;

  List<List<GooglePlaces>> get nearbySearchResults => _nearbySearchResults;
  bool get hasMultipleLists => _nearbySearchResults.length > 1;
  set nearbySearchResults(List<List<GooglePlaces>> value) {
    _nearbySearchResults = value;

    notifyListeners();
  }

  set nearbySearchParams(NearbySearchData? value) {
    _nearbySearchParams = value;
    notifyListeners();
  }

  Future<List<GooglePlaces>> fetchNearbySearch({
    String? keyword,
    String? nextPageToken,
  }) async {
    if (_nearbySearchParams == null) {
      return [];
    }

    final res = await client().nearbySearch(
      key: Env.googleMapsApiKey,
      location:
          '${_nearbySearchParams!.location.$1},${_nearbySearchParams!.location.$2}',
      radius:
          _nearbySearchParams!.radius == SearchRadius.focused ? 1500 : 20000,
      keyword: keyword,
      minPrice: _nearbySearchParams!.minPrice,
      maxPrice: _nearbySearchParams!.maxPrice,
      type: 'restaurant',
      next_page_token: nextPageToken,
    );

    if (res.status == STATUS_OK) {
      return res.results ?? [];
    } else {
      print('no data');
      return [];
    }
  }

  Future<void> fetchAllNearbyLocations() async {
    final List<List<GooglePlaces>> results = [];

    // if no food types selected,
    // call nearby serach api once only and add that to the list of results
    if (_nearbySearchParams?.foodTypes.isEmpty ?? true) {
      final places = await fetchNearbySearch();
      results.add(places);
    }
    // if food types selected,
    // call nearby search api as many times as the nunber of food types selected
    else {
      for (var i = 0; i < _nearbySearchParams!.foodTypes.length; i++) {
        final foodType = _nearbySearchParams!.foodTypes[i];
        final places = await fetchNearbySearch(keyword: foodType);

        results.add(places);
      }
    }

    _nearbySearchResults = results;
  }

  GooglePlaces? getOneRandomPlace() {
    if (_nearbySearchResults.isEmpty) {
      return null;
    }

    // if only one category is displayed
    if (_nearbySearchResults.length == 1) {
      if (_nearbySearchResults[0].isEmpty) {
        return null;
      }

      final randomIndex = Random().nextInt(_nearbySearchResults[0].length);
      return _nearbySearchResults[0][randomIndex];
    }

    // if more than one category is displayed
    else {
      final randomCategoryIndex = Random().nextInt(_nearbySearchResults.length);
      if (_nearbySearchResults[randomCategoryIndex].isEmpty) {
        return null;
      }

      final randomItemIndex =
          Random().nextInt(_nearbySearchResults[randomCategoryIndex].length);
      return _nearbySearchResults[randomCategoryIndex][randomItemIndex];
    }
  }
}
