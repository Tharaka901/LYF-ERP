import 'dart:convert';

import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/payment/payment_model.dart';

CreditPaymentModel creditPaymentModelFromJson(String str) =>
    CreditPaymentModel.fromJson(json.decode(str));

String creditPaymentModelToJson(CreditPaymentModel data) =>
    json.encode(data.toJson());

class CreditPaymentModel {
  final int? id;
  final double? value;
  final int? status;
  final int? paymentInvoiceId;
  final int? routecardId;
  final String? creditInvoiceId;
  final String? receiptNo;
  final DateTime? createdAt;
  final InvoiceModel? creditInvoice;
  final InvoiceModel? paymentInvoice;
  final List<PaymentModel>? payments;

  CreditPaymentModel({
    this.id,
    this.value,
    this.status,
    this.paymentInvoiceId,
    this.routecardId,
    this.creditInvoiceId,
    this.receiptNo,
    this.createdAt,
    this.creditInvoice,
    this.paymentInvoice,
    this.payments,
  });

  factory CreditPaymentModel.fromJson(Map<String, dynamic> json) =>
      CreditPaymentModel(
        id: json["id"],
        value: json["value"] is int ? json["value"].toDouble() : json["value"],
        status: json["status"],
        paymentInvoiceId: json["paymentInvoiceId"],
        routecardId: json["routecardId"],
        creditInvoiceId: json["creditInvoiceId"],
        receiptNo: json["receiptNo"],
        // createdAt: json["createdAt"] == null
        //     ? null
        //     : DateTime.parse(json["createdAt"]),
        creditInvoice: json["creditInvoice"] == null
            ? null
            : InvoiceModel.fromJson(json["creditInvoice"]),
        paymentInvoice: json["paymentInvoice"] == null
            ? null
            : InvoiceModel.fromJson(json["paymentInvoice"]),
        payments: json["payments"] == null
            ? []
            : List<PaymentModel>.from(
                json["payments"]!.map((x) => PaymentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "status": status,
        "paymentInvoiceId": paymentInvoiceId,
        "routecardId": routecardId,
        "creditInvoiceId": creditInvoiceId,
        "receiptNo": receiptNo,
        // "createdAt": createdAt?.toIso8601String(),
        "creditInvoice": creditInvoice?.toJson(),
        "paymentInvoice": paymentInvoice?.toJson(),
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
      };
}
