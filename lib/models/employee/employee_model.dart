import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  final int? employeeId;
  final String? employeeRegNo;
  final DateTime? appointmentDate;
  final String? firstName;
  final String? lastName;
  final String? address;
  final DateTime? dob;
  final String? epfNo;
  final int? roleId;
  final int? salaryId;
  final int? status;
  final String? nic;
  final String? password;
  final String? contactNumber;

  EmployeeModel({
    this.employeeId,
    this.employeeRegNo,
    this.appointmentDate,
    this.firstName,
    this.lastName,
    this.address,
    this.dob,
    this.epfNo,
    this.roleId,
    this.salaryId,
    this.status,
    this.nic,
    this.password,
    this.contactNumber,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        employeeId: json["employeeId"],
        employeeRegNo: json["employeeRegNo"],
        appointmentDate: json["appointmentDate"] == null
            ? null
            : DateTime.parse(json["appointmentDate"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        epfNo: json["epfNo"],
        roleId: json["roleId"],
        salaryId: json["salaryId"],
        status: json["status"],
        nic: json["nic"],
        password: json["password"],
        contactNumber: json["contactNumber"],
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "employeeRegNo": employeeRegNo,
        "appointmentDate":
            "${appointmentDate!.year.toString().padLeft(4, '0')}-${appointmentDate!.month.toString().padLeft(2, '0')}-${appointmentDate!.day.toString().padLeft(2, '0')}",
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "epfNo": epfNo,
        "roleId": roleId,
        "salaryId": salaryId,
        "status": status,
        "nic": nic,
        "password": password,
        "contactNumber": contactNumber,
      };
}
