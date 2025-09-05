// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteCard _$RouteCardFromJson(Map<String, dynamic> json) => RouteCard(
      routeCardId: json['routeCardId'] as int,
      routeCardNo: json['routeCardNo'] as String,
      routeId: json['routeId'] as int,
      vehicleId: json['vehicleId'] as int,
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      date: json['date'] as String?,
      route: Route.fromJson(json['route'] as Map<String, dynamic>),
      relatedEmployees: (json['relatedEmployees'] as List<dynamic>)
          .map((e) => RelatedEmployee.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int,
    );

Map<String, dynamic> _$RouteCardToJson(RouteCard instance) => <String, dynamic>{
      'routeCardId': instance.routeCardId,
      'routeCardNo': instance.routeCardNo,
      'routeId': instance.routeId,
      'vehicleId': instance.vehicleId,
      'vehicle': instance.vehicle?.toJson(),
      'date': instance.date,
      'route': instance.route,
      'relatedEmployees': instance.relatedEmployees,
      'status': instance.status,
    };
