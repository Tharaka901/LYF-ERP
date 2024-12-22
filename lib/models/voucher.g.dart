// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherModel _$VoucherFromJson(Map<String, dynamic> json) => VoucherModel(
      id: json['id'] as int,
      code: json['code'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$VoucherToJson(VoucherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'value': instance.value,
    };
