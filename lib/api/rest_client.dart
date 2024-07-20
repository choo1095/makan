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
  Future<GoogleRes<List<GooglePlaces>>> nearbySearch();
}

RestClient client() {
  final dio = DioHelper.getInstance();
  return RestClient(dio);
}
