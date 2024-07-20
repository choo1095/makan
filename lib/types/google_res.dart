// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'google_res.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class GoogleRes<T> {
  const GoogleRes({this.next_page_token, this.results, this.status});

  final String? next_page_token;
  final T? results;
  final String? status;

  factory GoogleRes.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$GoogleResFromJson<T>(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return _$GoogleResToJson<T>(this, toJsonT);
  }
}
