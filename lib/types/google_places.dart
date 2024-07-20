import 'package:json_annotation/json_annotation.dart';

part 'google_places.g.dart';

@JsonSerializable()
class GooglePlaces {
  Geometry? geometry;
  String? name;
  OpeningHours? openingHours;
  List<Photo>? photos;
  String? placeId;
  int? priceLevel;
  double? rating;
  String? reference;
  List<String>? types;
  int? userRatingsTotal;
  String? vicinity;

  GooglePlaces({
    this.geometry,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.priceLevel,
    this.rating,
    this.reference,
    this.types,
    this.userRatingsTotal,
    this.vicinity,
  });

  factory GooglePlaces.fromJson(Map<String, dynamic> json) =>
      _$GooglePlacesFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePlacesToJson(this);
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
  bool? openNow;

  OpeningHours({
    this.openNow,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class Photo {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
