import 'package:gsr/models/related_employee.dart';
import 'package:gsr/models/route.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'route_card.g.dart';

@JsonSerializable()
class RouteCard {
  final int routeCardId;
  final String routeCardNo;
  final int routeId;
  final int vehicleId;
  final String? date;
  final Route route;
  final List<RelatedEmployee> relatedEmployees;
  int status;

  RouteCard({
    required this.routeCardId,
    required this.routeCardNo,
    required this.routeId,
    required this.vehicleId,
    required this.date,
    required this.route,
    required this.relatedEmployees,
    required this.status,
  });

  RouteCard acceptedRouteCard() {
    status = 1;
    return this;
  }

  RouteCard rejectedRouteCard() {
    status = 4;
    return this;
  }

  factory RouteCard.fromJson(Map<String, dynamic> json) =>
      _$RouteCardFromJson(json);

  Map<String, dynamic> toJson() => _$RouteCardToJson(this);
}
