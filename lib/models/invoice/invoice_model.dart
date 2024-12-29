import 'package:gsr/models/customer/customer_model.dart';

import '../../commons/common_methods.dart';
import '../employee/employee_model.dart';

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
  final String? creditValue;
  final int? employeeId;
  final int? status;
  final CustomerModel? customer;
  final EmployeeModel? employee;
  final String? createdAt;

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
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
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
          : json["creditValue"],
      employeeId: json["employeeId"],
      status: json["status"],
      createdAt: json["createdAt"] == null
          ? null
          : date(DateTime.parse(json["createdAt"]), format: 'dd.MM.yyyy'),
      customer: json["customer"] == null
          ? null
          : CustomerModel.fromJson(json["customer"]),
      employee: json["employee"] == null
          ? null
          : EmployeeModel.fromJson(json["employee"]));

  Map<String, dynamic> toJson() => {
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
        "createdAt": createdAt,
        "customer": customer?.toJson(),
      };
}
