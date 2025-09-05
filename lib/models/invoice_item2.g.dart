// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem2 _$InvoiceItem2FromJson(Map<String, dynamic> json) => InvoiceItem2(
      item: json['item'] == null
          ? null
          : Item2.fromJson(json['item'] as Map<String, dynamic>),
      itemPrice: (json['itemPrice'] as num).toDouble(),
      itemQty: (json['itemQty'] as num).toDouble(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$InvoiceItem2ToJson(InvoiceItem2 instance) =>
    <String, dynamic>{
      'item': instance.item,
      'itemPrice': instance.itemPrice,
      'itemQty': instance.itemQty,
      'status': instance.status,
    };
