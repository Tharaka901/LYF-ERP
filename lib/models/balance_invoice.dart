// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'balance_invoice.g.dart';

@JsonSerializable()
class BalanceInvoice {
  final String invoiceNo;
  final int routecardId;
  final double amount;
  final int customerId;
  final int customerBalanceId;
  final int employeeId;

  BalanceInvoice({
    required this.invoiceNo,
    required this.routecardId,
    required this.amount,
    required this.customerId,
    required this.customerBalanceId,
    required this.employeeId,
  });

  factory BalanceInvoice.fromJson(Map<String, dynamic> json) =>
      _$BalanceInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceInvoiceToJson(this);
}
