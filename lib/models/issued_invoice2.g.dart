// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issued_invoice2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssuedInvoice2 _$IssuedInvoice2FromJson(Map<String, dynamic> json) =>
    IssuedInvoice2(
      invoiceId: json['invoiceId'] as int,
      invoiceNo: json['invoiceNo'] as String,
      routecardId: json['routecardId'] as int,
      amount: (json['amount'] as num).toDouble(),
      customerId: json['customerId'] as int,
      employeeId: json['employeeId'] as int,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$IssuedInvoice2ToJson(IssuedInvoice2 instance) =>
    <String, dynamic>{
      'invoiceId': instance.invoiceId,
      'invoiceNo': instance.invoiceNo,
      'routecardId': instance.routecardId,
      'amount': instance.amount,
      'customerId': instance.customerId,
      'employeeId': instance.employeeId,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
