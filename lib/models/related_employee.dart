// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'employee.dart';

part 'related_employee.g.dart';

@JsonSerializable()
class RelatedEmployee {
  final int routecardEmployeesId;
  final Employee employee;

  RelatedEmployee({
    required this.routecardEmployeesId,
    required this.employee,
  });

  factory RelatedEmployee.fromJson(Map<String, dynamic> json) => _$RelatedEmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedEmployeeToJson(this);
}
