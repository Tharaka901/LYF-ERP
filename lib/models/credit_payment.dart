// ignore: depend_on_referenced_packages

import 'package:gsr/models/invoice3.dart';
import 'package:gsr/models/payment.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'credit_payment.g.dart';

@JsonSerializable()
class CreditPayment {
  final int? id;
  final double value;
  final String receiptNo;
  final Invoice3? creditInvoice;
  final List<Payment>? payments;
  final int? status;
  final DateTime? createdAt;

  CreditPayment(
      {required this.id,
      required this.receiptNo,
      required this.creditInvoice,
      required this.value,
      this.createdAt,
      this.payments,
      required this.status});

  factory CreditPayment.fromJson(Map<String, dynamic> json) =>
      _$CreditPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$CreditPaymentToJson(this);
}
