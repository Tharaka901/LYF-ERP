// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      invoiceItems: (json['invoiceItems'] as List<dynamic>?)
          ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoiceNo: json['invoiceNo'] as String,
      routecardId: json['routecardId'] as int,
      amount: (json['amount'] as num).toDouble(),
      subTotal: (json['subTotal'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      customerId: json['customerId'] as int,
      employeeId: json['employeeId'] as int,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'invoiceNo': instance.invoiceNo,
      'routecardId': instance.routecardId,
      'amount': instance.amount,
      'customerId': instance.customerId,
      'employeeId': instance.employeeId,
      'customer': instance.customer,
      'invoiceItems': instance.invoiceItems,
    };
