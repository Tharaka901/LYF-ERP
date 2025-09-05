// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditPayment _$CreditPaymentFromJson(Map<String, dynamic> json) =>
    CreditPayment(
      id: json['id'] as int?,
      receiptNo: json['receiptNo'] as String,
      creditInvoice: json['creditInvoice'] == null
          ? null
          : Invoice3.fromJson(json['creditInvoice'] as Map<String, dynamic>),
      value: (json['value'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$CreditPaymentToJson(CreditPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'receiptNo': instance.receiptNo,
      'creditInvoice': instance.creditInvoice,
      'payments': instance.payments,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
