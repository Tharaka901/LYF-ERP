// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balance _$BalanceFromJson(Map<String, dynamic> json) => Balance(
      customerBalanceId: json['customerBalanceId'] as int,
      balanceAmount: (json['balanceAmount'] as num).toDouble(),
      invoice: BalanceInvoice.fromJson(json['invoice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'customerBalanceId': instance.customerBalanceId,
      'balanceAmount': instance.balanceAmount,
      'invoice': instance.invoice,
    };
