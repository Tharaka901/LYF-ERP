// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      paymentId: json['paymentId'] as int?,
      customerTypeId: json['customerTypeId'] as int?,
      invoiceId: json['invoiceId'] as int?,
      amount: (json['amount'] as num).toDouble(),
      receiptNo: json['receiptNo'] as String,
      paymentMethod: json['paymentMethod'] as int?,
      routecardId: json['routecardId'] as int?,
      routeId: json['routeId'] as int?,
      chequeNo: json['chequeNo'] as String?,
      customerId: json['customerId'] as int?,
      priceLevelId: json['priceLevelId'] as int?,
      employeeId: json['employeeId'] as int?,
      status: json['status'] as int?,
      paymentMethods: json['paymentMethods'] == null
          ? null
          : PaymentMethod.fromJson(
              json['paymentMethods'] as Map<String, dynamic>),
      invoice: json['invoice'] == null
          ? null
          : Invoice.fromJson(json['invoice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'paymentId': instance.paymentId,
      'invoiceId': instance.invoiceId,
      'amount': instance.amount,
      'receiptNo': instance.receiptNo,
      'paymentMethod': instance.paymentMethod,
      'routecardId': instance.routecardId,
      'routeId': instance.routeId,
      'chequeNo': instance.chequeNo,
      'customerId': instance.customerId,
      'customerTypeId': instance.customerTypeId,
      'priceLevelId': instance.priceLevelId,
      'employeeId': instance.employeeId,
      'status': instance.status,
      'paymentMethods': instance.paymentMethods,
      'invoice': instance.invoice,
    };
