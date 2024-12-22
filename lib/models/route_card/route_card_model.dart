import 'dart:convert';

import 'package:gsr/models/related_employee/related_employee_model.dart';
import 'package:gsr/models/route/route_model.dart';

RouteCardModel routeCardModelFromJson(String str) =>
    RouteCardModel.fromJson(json.decode(str));

String routeCardModelToJson(RouteCardModel data) => json.encode(data.toJson());

class RouteCardModel {
  final int? routeCardId;
  final String? routeCardNo;
  final DateTime? date;
  final int? routeId;
  final int? vehicleId;
  int? status;
  final RouteModel? route;
  final List<RelatedEmployeeModel>? relatedEmployees;

  RouteCardModel({
    this.routeCardId,
    this.routeCardNo,
    this.date,
    this.routeId,
    this.vehicleId,
    this.status,
    this.route,
    this.relatedEmployees,
  });

  RouteCardModel acceptedRouteCard() {
    status = 1;
    return this;
  }

  RouteCardModel rejectedRouteCard() {
    status = 4;
    return this;
  }

  factory RouteCardModel.fromJson(Map<dynamic, dynamic> json) => RouteCardModel(
        routeCardId: json["routeCardId"],
        routeCardNo: json["routeCardNo"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        status: json["status"],
        route:
            json["route"] == null ? null : RouteModel.fromJson(json["route"]),
        relatedEmployees: json["relatedEmployees"] == null
            ? []
            : List<RelatedEmployeeModel>.from(json["relatedEmployees"]!
                .map((x) => RelatedEmployeeModel.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "routeCardId": routeCardId,
        "routeCardNo": routeCardNo,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "routeId": routeId,
        "vehicleId": vehicleId,
        "status": status,
        "route": route?.toJson(),
        "relatedEmployees": relatedEmployees == null
            ? []
            : List<dynamic>.from(relatedEmployees!.map((x) => x.toJson())),
      };
}
