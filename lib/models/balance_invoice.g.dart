// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceInvoice _$BalanceInvoiceFromJson(Map<String, dynamic> json) =>
    BalanceInvoice(
      invoiceNo: json['invoiceNo'] as String,
      routecardId: json['routecardId'] as int,
      amount: (json['amount'] as num).toDouble(),
      customerId: json['customerId'] as int,
      customerBalanceId: json['customerBalanceId'] as int,
      employeeId: json['employeeId'] as int,
    );

Map<String, dynamic> _$BalanceInvoiceToJson(BalanceInvoice instance) =>
    <String, dynamic>{
      'invoiceNo': instance.invoiceNo,
      'routecardId': instance.routecardId,
      'amount': instance.amount,
      'customerId': instance.customerId,
      'customerBalanceId': instance.customerBalanceId,
      'employeeId': instance.employeeId,
    };
