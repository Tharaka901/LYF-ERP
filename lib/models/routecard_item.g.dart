// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routecard_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutecardItem _$RoutecardItemFromJson(Map<String, dynamic> json) =>
    RoutecardItem(
      routecardItemsId: json['routecardItemsId'] as int,
      itemId: json['itemId'] as int,
      transferQty: (json['transferQty'] as num).toDouble(),
      sellQty: (json['sellQty'] as num).toDouble(),
      routecardId: json['routecardId'] as int,
      status: json['status'] as int,
      item: json['item'] == null
          ? null
          : Item.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoutecardItemToJson(RoutecardItem instance) =>
    <String, dynamic>{
      'routecardItemsId': instance.routecardItemsId,
      'itemId': instance.itemId,
      'transferQty': instance.transferQty,
      'sellQty': instance.sellQty,
      'routecardId': instance.routecardId,
      'status': instance.status,
      'item': instance.item,
    };
