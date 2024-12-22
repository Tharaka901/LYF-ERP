import 'package:gsr/models/credit_payment.dart';
import 'package:gsr/models/customer.dart';
import 'package:gsr/models/invoice_item2.dart';
import 'package:gsr/models/payment.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'issued_invoice.g.dart';

@JsonSerializable()
class IssuedInvoice {
  final int? invoiceId;
  final String invoiceNo;
  final int? routecardId;
  final double amount;
  final double? subTotal;
  final double? vat;
  final double? nonVatItemTotal;
  final Customer customer;
  final double creditValue;
  final int? employeeId;
  final int? status;
  final List<InvoiceItem2> items;
  final List<Payment> payments;
  final List<CreditPayment>? previousPayments;
  final DateTime createdAt;
  final int? chequeId;

  IssuedInvoice({
    required this.invoiceId,
    required this.invoiceNo,
    required this.routecardId,
    required this.amount,
    required this.customer,
    required this.creditValue,
    required this.employeeId,
    required this.status,
    required this.items,
    required this.payments,
    required this.previousPayments,
    required this.createdAt,
    this.chequeId,
    this.subTotal,
    this.vat,
    this.nonVatItemTotal,
  });

  factory IssuedInvoice.fromJson(Map<String, dynamic> json) =>
      _$IssuedInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$IssuedInvoiceToJson(this);
}
