// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      itemPrice: (json['itemPrice'] as num).toDouble(),
      itemQty: (json['itemQty'] as num).toDouble(),
      status: json['status'] as int,
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) =>
    <String, dynamic>{
      'item': instance.item,
      'itemPrice': instance.itemPrice,
      'itemQty': instance.itemQty,
      'status': instance.status,
    };
