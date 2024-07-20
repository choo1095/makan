// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'google_geocode.g.dart';

@JsonSerializable()
class GoogleGeocode {
  const GoogleGeocode({this.geometry, this.formatted_address});

  final Geometry? geometry;
  final String? formatted_address;

  factory GoogleGeocode.fromJson(Map<String, dynamic> json) =>
      _$GoogleGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleGeocodeToJson(this);
}

@JsonSerializable()
class Geometry {
  Location? location;

  Geometry({
    this.location,
  });

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
