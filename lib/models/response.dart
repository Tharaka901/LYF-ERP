// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class Respo {
  final bool success;
  final dynamic data;
  final String? error;

  Respo({
    required this.success,
    this.data,
    this.error,
  });

  factory Respo.fromJson(Map<String, dynamic> json) =>
      _$RespoFromJson(json);

  Map<String, dynamic> toJson() => _$RespoToJson(this);
}
