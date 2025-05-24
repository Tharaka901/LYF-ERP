import '../invoice/invoice_model.dart';
import '../payment_method/payment_method.dart';

class PaymentModel {
  final int? paymentId;
  final int? invoiceId;
  final double? amount;
  final String? receiptNo;
  final int? paymentMethod;
  final int? routecardId;
  final int? routeId;
  final String? chequeNo;
  final int? customerId;
  final int? customerTypeId;
  final int? priceLevelId;
  final int? employeeId;
  final int? status;
  final PaymentMethodModel? paymentMethods;
  final InvoiceModel? invoice;

  PaymentModel({
    this.paymentId,
    this.invoiceId,
    this.amount,
    this.receiptNo,
    this.paymentMethod,
    this.routecardId,
    this.routeId,
    this.chequeNo,
    this.customerId,
    this.customerTypeId,
    this.priceLevelId,
    this.employeeId,
    this.status,
    this.paymentMethods,
    this.invoice,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        paymentId: json["paymentId"],
        invoiceId: json["invoiceId"],
        amount:
            json["amount"] is int ? json["amount"].toDouble() : json["amount"],
        receiptNo: json["receiptNo"],
        paymentMethod: json["paymentMethod"],
        routecardId: json["routecardId"],
        routeId: json["routeId"],
        chequeNo: json["chequeNo"],
        customerId: json["customerId"],
        customerTypeId: json["customerTypeId"],
        priceLevelId: json["priceLevelId"],
        employeeId: json["employeeId"],
        status: json["status"],
        paymentMethods: json["paymentMethods"] == null
            ? null
            : PaymentMethodModel.fromJson(json["paymentMethods"]),
        invoice: json["invoice"] == null
            ? null
            : InvoiceModel.fromJson(json["invoice"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
        "invoiceId": invoiceId,
        "amount": amount,
        "receiptNo": receiptNo,
        "paymentMethod": paymentMethod,
        "routecardId": routecardId,
        "routeId": routeId,
        "chequeNo": chequeNo,
        "customerId": customerId,
        "customerTypeId": customerTypeId,
        "priceLevelId": priceLevelId,
        "employeeId": employeeId,
        "status": status,
        "paymentMethods": paymentMethods?.toJson(),
        "invoice": invoice?.toJson(),
      };
}
