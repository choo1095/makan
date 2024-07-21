// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:makan/env/env.dart';

part 'google_places.g.dart';

@JsonSerializable()
class GooglePlaces {
  Geometry? geometry;
  String? name;
  OpeningHours? opening_hours;
  List<Photo>? photos;
  String? place_id;
  int? price_level;
  double? rating;
  String? reference;
  List<String>? types;
  int? user_ratings_total;
  String? vicinity;

  GooglePlaces({
    this.geometry,
    this.name,
    this.opening_hours,
    this.photos,
    this.place_id,
    this.price_level,
    this.rating,
    this.reference,
    this.types,
    this.user_ratings_total,
    this.vicinity,
  });

  factory GooglePlaces.fromJson(Map<String, dynamic> json) =>
      _$GooglePlacesFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePlacesToJson(this);

  String? get placeImage {
    final photoReference = photos?.firstOrNull?.photo_reference;
    if (photoReference == null) {
      return '';
    }

    return 'https://maps.googleapis.com/maps/api/place/photo?photoreference=$photoReference&maxwidth=400&key=${Env.googleMapsApiKey}';
  }

  String? get mapsUrl {
    if (place_id == null || name == null) {
      return null;
    }

    return 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(name!)}&query_place_id=$place_id';
  }
}

@JsonSerializable()
class Geometry {
  Location? location;

  Geometry({
    this.location,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class OpeningHours {
  bool? open_now;

  OpeningHours({
    this.open_now,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class Photo {
  int? height;
  List<String>? html_attributions;
  String? photo_reference;
  int? width;

  Photo({
    this.height,
    this.html_attributions,
    this.photo_reference,
    this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
