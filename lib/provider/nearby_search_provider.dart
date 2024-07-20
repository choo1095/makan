import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/api/rest_client.dart';

final nearbySearchProvider = ChangeNotifierProvider((ref) => NearbySearchProvider());

class NearbySearchProvider extends ChangeNotifier {
  
  void fetchNearbySearch((double lat, double lon) location) async {
    final res = await client().nearbySearch()
  } 
}
