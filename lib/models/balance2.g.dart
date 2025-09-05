// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balance2 _$Balance2FromJson(Map<String, dynamic> json) => Balance2(
      customerBalanceId: json['customerBalanceId'] as int,
      balanceAmount: (json['balanceAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$Balance2ToJson(Balance2 instance) => <String, dynamic>{
      'customerBalanceId': instance.customerBalanceId,
      'balanceAmount': instance.balanceAmount,
    };
