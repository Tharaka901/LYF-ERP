import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/payment_method/payment_method.dart';

class ReceiptModel {
  final String? businessName;
  final String? customerVatNu;
  final String? employee;
  final String? billingDate;
  final String createdAt;
  final String receiptNo;
  final double totalPayment;
   final double totalPreviousPayment;
  final List<InvoiceModel> invoicess;
  final List<PaymentMethodModel> paymentMethods;

  ReceiptModel({
    required this.totalPayment,
    this.customerVatNu,
    required this.createdAt,
    required this.receiptNo,
    required this.invoicess,
    this.businessName,
    required this.paymentMethods,
    this.billingDate,
    this.employee,
    required this.totalPreviousPayment,
  });
}
