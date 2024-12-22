// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paid_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaidBalance _$PaidBalanceFromJson(Map<String, dynamic> json) => PaidBalance(
      balance: Balance.fromJson(json['balance'] as Map<String, dynamic>),
      payment: (json['payment'] as num).toDouble(),
    );

Map<String, dynamic> _$PaidBalanceToJson(PaidBalance instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'payment': instance.payment,
    };
