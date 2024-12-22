import 'package:gsr/models/employee/employee_model.dart';

class RelatedEmployeeModel {
  final int? routecardEmployeesId;
  final int? employeeId;
  final int? routecardId;
  final EmployeeModel? employee;

  RelatedEmployeeModel({
    this.routecardEmployeesId,
    this.employeeId,
    this.routecardId,
    this.employee,
  });

  factory RelatedEmployeeModel.fromJson(Map<dynamic, dynamic> json) =>
      RelatedEmployeeModel(
        routecardEmployeesId: json["routecardEmployeesId"],
        employeeId: json["employeeId"],
        routecardId: json["routecardId"],
        employee: json["employee"] == null
            ? null
            : EmployeeModel.fromJson(json["employee"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "routecardEmployeesId": routecardEmployeesId,
        "employeeId": employeeId,
        "routecardId": routecardId,
        "employee": employee?.toJson(),
      };
}
