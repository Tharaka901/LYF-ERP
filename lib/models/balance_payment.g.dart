// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalancePayment _$BalancePaymentFromJson(Map<String, dynamic> json) =>
    BalancePayment(
      id: json['id'] as int,
      value: (json['value'] as num).toDouble(),
      invoiceId: json['invoiceId'] as int,
      routecardId: json['routecardId'] as int,
      customerBalanceId: json['customerBalanceId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      invoice: IssuedInvoice2.fromJson(json['invoice'] as Map<String, dynamic>),
      customerBalance:
          Balance2.fromJson(json['customerBalance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BalancePaymentToJson(BalancePayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'invoiceId': instance.invoiceId,
      'routecardId': instance.routecardId,
      'customerBalanceId': instance.customerBalanceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'invoice': instance.invoice,
      'customerBalance': instance.customerBalance,
    };
