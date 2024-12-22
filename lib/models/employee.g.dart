// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      employeeId: json['employeeId'] as int,
      employeeRegNo: json['employeeRegNo'] as String?,
      appointmentDate: json['appointmentDate'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      epfNo: json['epfNo'] as String?,
      roleId: json['roleId'] as int,
      salaryId: json['salaryId'] as int,
      nic: json['nic'] as String?,
      status: json['status'] as int,
      password: json['password'] as String?,
      contactNumber: json['contactNumber'] as String?,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeRegNo': instance.employeeRegNo,
      'appointmentDate': instance.appointmentDate,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'address': instance.address,
      'dob': instance.dob,
      'epfNo': instance.epfNo,
      'roleId': instance.roleId,
      'salaryId': instance.salaryId,
      'nic': instance.nic,
      'status': instance.status,
      'password': instance.password,
      'contactNumber': instance.contactNumber,
    };
