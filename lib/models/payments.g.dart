// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payments _$PaymentsFromJson(Map<String, dynamic> json) => Payments(
      payments: (json['payments'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$PaymentsToJson(Payments instance) => <String, dynamic>{
      'payments': instance.payments,
    };
