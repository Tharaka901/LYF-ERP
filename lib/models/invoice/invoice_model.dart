import 'package:gsr/models/credit_payment/credit_payment_model.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/models/payment/payment_model.dart';
import 'package:gsr/models/route_card/route_card_model.dart';

import '../employee/employee_model.dart';
import '../invoice_item/invoice_item_model.dart';

class InvoiceModel {
  final int? invoiceId;
  final String invoiceNo;
  final int? routecardId;
  final double? paymentAmount;
  final double? amount;
  final double? subTotal;
  final double? vat;
  final double? nonVatItemTotal;
  final int? customerId;
  final double? creditValue;
  final int? employeeId;
  final int? status;
  CustomerModel? customer;
  final EmployeeModel? employee;
  final DateTime? createdAt;
  final List<InvoiceItemModel>? invoiceItems;
  List<PaymentModel>? payments;
  List<CreditPaymentModel>? previousPayments;
  final int? chequeId;
  final RouteCardModel? routeCard;

  InvoiceModel({
    this.invoiceId,
    this.routecardId,
    this.amount,
    this.subTotal,
    this.vat,
    this.nonVatItemTotal,
    this.customerId,
    this.creditValue,
    this.employeeId,
    this.status,
    this.customer,
    required this.invoiceNo,
    this.paymentAmount,
    this.createdAt,
    this.employee,
    this.invoiceItems,
    this.payments,
    this.previousPayments,
    this.chequeId,
    this.routeCard,
  });

  factory InvoiceModel.fromJson(Map<dynamic, dynamic> json) => InvoiceModel(
        invoiceId: json["invoiceId"],
        invoiceNo: json["invoiceNo"],
        routecardId: json["routecardId"],
        amount:
            json["amount"] is int ? json["amount"].toDouble() : json["amount"],
        subTotal: json["subTotal"] is int
            ? json["subTotal"].toDouble()
            : json["subTotal"],
        vat: json["vat"] is int ? json["vat"].toDouble() : json["vat"],
        nonVatItemTotal: json["nonVatItemTotal"] is int
            ? json["nonVatItemTotal"].toDouble()
            : json["nonVatItemTotal"],
        customerId: json["customerId"],
        creditValue: json["creditValue"] is int
            ? json["creditValue"].toDouble()
            : json["creditValue"] is String
                ? double.parse(json["creditValue"])
                : json["creditValue"],
        employeeId: json["employeeId"],
        status: json["status"],
        createdAt: json["createdAt"] is String
            ? DateTime.parse(json["createdAt"])
            : json["createdAt"],
        customer: json["customer"] == null
            ? null
            : CustomerModel.fromJson(json["customer"]),
        employee: json["employee"] == null
            ? null
            : EmployeeModel.fromJson(json["employee"]),
        invoiceItems: json["items"] != null
            ? List<InvoiceItemModel>.from(
                json["items"].map((x) => InvoiceItemModel.fromJson(x)),
              )
            : [],
        payments: json["payments"] == null
            ? []
            : List<PaymentModel>.from(
                json["payments"]!.map((x) => PaymentModel.fromJson(x)),
              ),
        previousPayments: json["previousPayments"] == null
            ? []
            : List<CreditPaymentModel>.from(
                json["previousPayments"]!
                    .map((x) => CreditPaymentModel.fromJson(x)),
              ),
        routeCard: json["routeCard"] == null
            ? null
            : RouteCardModel.fromJson(json["routeCard"]),
        chequeId: json["chequeId"],
      );

  Map<String, dynamic> toJson() => {
        "invoiceNo": invoiceNo,
        "routecardId": routecardId,
        "amount": amount,
        "subTotal": subTotal,
        "vat": vat,
        "nonVatItemTotal": nonVatItemTotal,
        "customerId": customerId,
        "creditValue": creditValue,
        "employeeId": employeeId,
        "status": status,
        "customer": customer?.toJson(),
        "invoiceItems": invoiceItems,
        "createdAt": createdAt?.toIso8601String(),
      };

  Map<String, dynamic> toJsonWithId() => {
        "invoiceId": invoiceId,
        "invoiceNo": invoiceNo,
        "routecardId": routecardId,
        "amount": amount,
        "subTotal": subTotal,
        "vat": vat,
        "nonVatItemTotal": nonVatItemTotal,
        "customerId": customerId,
        "creditValue": creditValue,
        "employeeId": employeeId,
        "status": status,
        "customer": customer?.toJson(),
        "invoiceItems": invoiceItems,
        "createdAt": createdAt?.toIso8601String(),
      };
}
