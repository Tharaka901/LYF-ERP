// ignore: depend_on_referenced_packages
import 'package:gsr/models/customer.dart';
import 'package:gsr/models/invoice_item.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  final String invoiceNo;
  final int routecardId;
  final double amount;
  final double? subTotal;
  final double? vat;
  final int customerId;
  final int employeeId;
  final Customer? customer;
  final List<InvoiceItem>? invoiceItems;

  Invoice({
    this.invoiceItems,
    required this.invoiceNo,
    required this.routecardId,
    required this.amount,
    required this.customerId,
    required this.employeeId,
    this.customer,
    this.subTotal,
    this.vat,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
