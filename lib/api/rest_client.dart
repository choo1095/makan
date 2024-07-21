// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:makan/api/dio_helper.dart';
import 'package:makan/types/google_geocode.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/types/google_res.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://maps.googleapis.com/maps/api')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/geocode/json')
  Future<GoogleRes<List<GoogleGeocode>>> getGeocode({
    @Query('key') required String key,
    @Query('address') required String address,
    @Query('region') String? region = 'my',
  });

  @GET('/place/nearbysearch/json')
  Future<GoogleRes<List<GooglePlaces>>> nearbySearch({
    @Query('key') required String key,
    @Query('location') required String location,
    @Query('radius') required int radius,
    @Query('region') String? region = 'my',
    @Query('keyword') String? keyword,
    @Query('minprice') int? minprice = 0,
    @Query('maxprice') int? maxprice = 4,
    // @Query('type') String? type = 'restaurant',
    @Query('next_page_token') String? next_page_token,
  });
}

RestClient client() {
  final dio = DioHelper.getInstance();
  return RestClient(dio);
}
