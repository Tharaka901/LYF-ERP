// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice3 _$Invoice3FromJson(Map<String, dynamic> json) => Invoice3(
      invoiceNo: json['invoiceNo'] as String,
      routecardId: json['routecardId'] as int?,
      amount: (json['amount'] as num).toDouble(),
      customerId: json['customerId'] as int?,
      employeeId: json['employeeId'] as int?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$Invoice3ToJson(Invoice3 instance) => <String, dynamic>{
      'invoiceNo': instance.invoiceNo,
      'routecardId': instance.routecardId,
      'amount': instance.amount,
      'customerId': instance.customerId,
      'employeeId': instance.employeeId,
      'customer': instance.customer,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
