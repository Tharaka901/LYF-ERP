// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as int,
      itemRegNo: json['itemRegNo'] as String,
      itemName: json['itemName'] as String,
      costPrice: (json['costPrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      nonVatAmount: (json['nonVatAmount'] as num).toDouble(),
      openingQty: (json['openingQty'] as num).toDouble(),
      vendorId: json['vendorId'] as int,
      priceLevelId: json['priceLevelId'] as int,
      itemTypeId: json['itemTypeId'] as int,
      stockId: json['stockId'] as int,
      costAccId: json['costAccId'] as int,
      incomeAccId: json['incomeAccId'] as int,
      isNew: json['isNew'] as int,
      hasSpecialPrice: json['hasSpecialPrice'] == null
          ? null
          : SpecialPrice.fromJson(
              json['hasSpecialPrice'] as Map<String, dynamic>),
      status: json['status'] as int,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'itemRegNo': instance.itemRegNo,
      'itemName': instance.itemName,
      'costPrice': instance.costPrice,
      'salePrice': instance.salePrice,
      'nonVatAmount': instance.nonVatAmount,
      'openingQty': instance.openingQty,
      'vendorId': instance.vendorId,
      'priceLevelId': instance.priceLevelId,
      'itemTypeId': instance.itemTypeId,
      'stockId': instance.stockId,
      'costAccId': instance.costAccId,
      'incomeAccId': instance.incomeAccId,
      'isNew': instance.isNew,
      'hasSpecialPrice': instance.hasSpecialPrice,
      'status': instance.status,
    };
