// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  final int employeeId;
  final String? employeeRegNo;
  final String? appointmentDate;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? dob;
  final String? epfNo;
  final int roleId;
  final int salaryId;
  final String? nic;
  final int status;
  final String? password;
  final String? contactNumber;

  Employee({
    required this.employeeId,
    required this.employeeRegNo,
    required this.appointmentDate,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.dob,
    required this.epfNo,
    required this.roleId,
    required this.salaryId,
    required this.nic,
    required this.status,
    required this.password,
    required this.contactNumber,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
