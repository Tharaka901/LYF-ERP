// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedEmployee _$RelatedEmployeeFromJson(Map<String, dynamic> json) =>
    RelatedEmployee(
      routecardEmployeesId: json['routecardEmployeesId'] as int,
      employee: Employee.fromJson(json['employee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelatedEmployeeToJson(RelatedEmployee instance) =>
    <String, dynamic>{
      'routecardEmployeesId': instance.routecardEmployeesId,
      'employee': instance.employee,
    };
