import 'package:gsr/models/balance_invoice.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'balance.g.dart';

@JsonSerializable()
class Balance {
  final int customerBalanceId;
  final double balanceAmount;
  final BalanceInvoice invoice;

  Balance({
    required this.customerBalanceId,
    required this.balanceAmount,
    required this.invoice,
  });

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}
