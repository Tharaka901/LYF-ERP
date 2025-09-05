// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialPrice _$SpecialPriceFromJson(Map<String, dynamic> json) => SpecialPrice(
      priceId: json['priceId'] as int,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      status: json['status'] as int,
      nonVatAmount:  (json['nonVatAmount'] as num).toDouble()
    );

Map<String, dynamic> _$SpecialPriceToJson(SpecialPrice instance) =>
    <String, dynamic>{
      'priceId': instance.priceId,
      'itemPrice': instance.itemPrice,
      'status': instance.status,
      'nonVatAmount': instance.nonVatAmount,
    };
