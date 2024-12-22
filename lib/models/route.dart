// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable()
class Route {
  final int routeId;
  final String routeName;

  Route({
    required this.routeId,
    required this.routeName,
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}
