// ignore: depend_on_referenced_packages
import 'package:gsr/models/invoice.dart';
import 'package:gsr/models/payment_methods.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final int? paymentId;
  final int? invoiceId;
  final double amount;
  final String receiptNo;
  final int? paymentMethod;
  final int? routecardId;
  final int? routeId;
  final String? chequeNo;
  final int? customerId;
  final int? customerTypeId;
  final int? priceLevelId;
  final int? employeeId;
  final int? status;
  final PaymentMethod? paymentMethods;
  final Invoice? invoice;

  Payment({
    this.paymentId,
    required this.customerTypeId,
    required this.invoiceId,
    required this.amount,
    required this.receiptNo,
    required this.paymentMethod,
    required this.routecardId,
    required this.routeId,
    this.chequeNo,
    required this.customerId,
    required this.priceLevelId,
    required this.employeeId,
    required this.status,
    this.paymentMethods,
    this.invoice,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
