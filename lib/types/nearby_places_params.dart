import 'package:makan/provider/search_form_provider.dart';

class NearbySearchData {
  final (double lat, double lon) location;
  final List<String> foodTypes;
  final SearchRadius radius;
  final int minPrice;
  final int maxPrice;

  NearbySearchData({
    required this.location,
    required this.foodTypes,
    required this.radius,
    required this.minPrice,
    required this.maxPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'foodTypes': foodTypes,
      'radius': radius,
      'min_price': minPrice,
      'max_price': maxPrice,
    };
  }
}
