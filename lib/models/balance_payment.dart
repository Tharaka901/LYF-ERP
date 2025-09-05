import 'package:gsr/models/balance2.dart';
import 'package:gsr/models/issued_invoice2.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'balance_payment.g.dart';

@JsonSerializable()
class BalancePayment {
  final int id;
  final double value;
  final int invoiceId;
  final int routecardId;
  final int customerBalanceId;
  final DateTime createdAt;
  final IssuedInvoice2 invoice;
  final Balance2 customerBalance;

  BalancePayment({
    required this.id,
    required this.value,
    required this.invoiceId,
    required this.routecardId,
    required this.customerBalanceId,
    required this.createdAt,
    required this.invoice,
    required this.customerBalance,
  });

  factory BalancePayment.fromJson(Map<String, dynamic> json) =>
      _$BalancePaymentFromJson(json);

  Map<String, dynamic> toJson() => _$BalancePaymentToJson(this);
}
