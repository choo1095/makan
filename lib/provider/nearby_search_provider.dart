import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/api/rest_client.dart';
import 'package:makan/constants/places.dart';
import 'package:makan/env/env.dart';
import 'package:makan/provider/search_form_provider.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/types/nearby_places_params.dart';
import 'package:makan/types/result.dart';

final nearbySearchProvider =
    ChangeNotifierProvider((ref) => NearbySearchProvider());

class NearbySearchProvider extends ChangeNotifier {
  bool _isLoading = false;

  NearbySearchData? _nearbySearchParams;

  List<List<GooglePlaces>> _nearbySearchResults = [];
  String? _error;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  NearbySearchData? get nearbySearchParams => _nearbySearchParams;
  set nearbySearchParams(NearbySearchData? value) {
    _nearbySearchParams = value;
    notifyListeners();
  }

  List<List<GooglePlaces>> get nearbySearchResults => _nearbySearchResults;
  bool get hasMultipleLists => _nearbySearchResults.length > 1;
  set nearbySearchResults(List<List<GooglePlaces>> value) {
    _nearbySearchResults = value;

    notifyListeners();
  }

  String? get error => _error;
  set error(String? value) {
    _error = value;

    notifyListeners();
  }

  Future<Result<List<GooglePlaces>, String>> fetchNearbySearch({
    String? keyword,
    String? nextPageToken,
  }) async {
    if (_nearbySearchParams == null) {
      return const Failure('No nearby search params found.');
    }

    try {
      final res = await client().nearbySearch(
        key: Env.googleMapsApiKey,
        location:
            '${_nearbySearchParams!.location.$1},${_nearbySearchParams!.location.$2}',
        radius:
            _nearbySearchParams!.radius == SearchRadius.focused ? 1500 : 20000,
        keyword: keyword,
        minprice: _nearbySearchParams!.minPrice,
        maxprice: _nearbySearchParams!.maxPrice,
        next_page_token: nextPageToken,
      );

      if (res.status == STATUS_OK) {
        return Success(res.results ?? []);
      }

      if (res.status == STATUS_ZERO_RESULTS) {
        return Failure(error.toString());
      }

      return Failure(res.error_message ?? 'Something went wrong.');
    } catch (error) {
      return Failure(error.toString());
    }
  }

  Future<void> fetchAllNearbyLocations() async {
    final List<List<GooglePlaces>> results = [];

    try {
      // if no food types selected,
      // call nearby serach api once only and add that to the list of results
      if (_nearbySearchParams?.foodTypes.isEmpty ?? true) {
        final res = await fetchNearbySearch();

        switch (res) {
          case Success(value: final placeList):
            results.add(placeList);
            break;
          case Failure(errorMessage: final exception):
            throw Exception(exception);
        }
      }
      // if food types selected,
      // call nearby search api as many times as the nunber of food types selected
      else {
        for (var i = 0; i < _nearbySearchParams!.foodTypes.length; i++) {
          final foodType = _nearbySearchParams!.foodTypes[i];
          final res = await fetchNearbySearch(keyword: foodType);

          switch (res) {
            case Success(value: final placeList):
              results.add(placeList);
              break;
            case Failure(errorMessage: final exception):
              throw Exception(exception);
          }
        }
      }

      _nearbySearchResults = results;
    } catch (error) {
      _error = error.toString();
    }
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

      final randomIndex = math.Random().nextInt(_nearbySearchResults[0].length);
      return _nearbySearchResults[0][randomIndex];
    }

    // if more than one category is displayed
    else {
      final randomCategoryIndex =
          math.Random().nextInt(_nearbySearchResults.length);
      if (_nearbySearchResults[randomCategoryIndex].isEmpty) {
        return null;
      }

      final randomItemIndex = math.Random()
          .nextInt(_nearbySearchResults[randomCategoryIndex].length);
      return _nearbySearchResults[randomCategoryIndex][randomItemIndex];
    }
  }
}
