
import 'package:gsr/models/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice3.g.dart';

@JsonSerializable()
class Invoice3 {
  final String invoiceNo;
  final int? routecardId;
  final double amount;
  final int? customerId;
  final int? employeeId;
  final Customer? customer;
  final DateTime? createdAt;

  Invoice3(
      {required this.invoiceNo,
      required this.routecardId,
      required this.amount,
      required this.customerId,
      required this.employeeId,
      this.customer,
      required this.createdAt});

  factory Invoice3.fromJson(Map<String, dynamic> json) =>
      _$Invoice3FromJson(json);

  Map<String, dynamic> toJson() => _$Invoice3ToJson(this);
}
