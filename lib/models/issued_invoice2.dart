// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'issued_invoice2.g.dart';

@JsonSerializable()
class IssuedInvoice2 {
  final int invoiceId;
  final String invoiceNo;
  final int routecardId;
  final double amount;
  final int customerId;
  final int employeeId;
  final int status;
  final DateTime createdAt;

  IssuedInvoice2({
    required this.invoiceId,
    required this.invoiceNo,
    required this.routecardId,
    required this.amount,
    required this.customerId,
    required this.employeeId,
    required this.status,
    required this.createdAt,
  });

  factory IssuedInvoice2.fromJson(Map<String, dynamic> json) =>
      _$IssuedInvoice2FromJson(json);

  Map<String, dynamic> toJson() => _$IssuedInvoice2ToJson(this);
}
