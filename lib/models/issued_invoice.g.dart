// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issued_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssuedInvoice _$IssuedInvoiceFromJson(Map<String, dynamic> json) =>
    IssuedInvoice(
      invoiceId: json['invoiceId'] as int?,
      invoiceNo: json['invoiceNo'] as String,
      routecardId: json['routecardId'] as int?,
      amount: (json['amount'] as num).toDouble(),
      subTotal: (json['subTotal'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      nonVatItemTotal: (json['nonVatItemTotal'] as num).toDouble(),
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      creditValue: double.parse(json['creditValue'].toString()),
      employeeId: json['employeeId'] as int?,
      status: json['status'] as int?,
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItem2.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      previousPayments: (json['previousPayments'] as List<dynamic>?)
          ?.map((e) => CreditPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      chequeId: json['chequeId'] as int?,
    );

Map<String, dynamic> _$IssuedInvoiceToJson(IssuedInvoice instance) =>
    <String, dynamic>{
      'invoiceId': instance.invoiceId,
      'invoiceNo': instance.invoiceNo,
      'routecardId': instance.routecardId,
      'amount': instance.amount,
      'customer': instance.customer,
      'creditValue': instance.creditValue,
      'employeeId': instance.employeeId,
      'status': instance.status,
      'items': instance.items,
      'payments': instance.payments,
      'previousPayments': instance.previousPayments,
      'createdAt': instance.createdAt.toIso8601String(),
      'chequeId': instance.chequeId
    };
