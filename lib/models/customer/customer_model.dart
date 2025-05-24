import '../vat/vat.dart';

class CustomerModel {
  final int? customerId;
  final String? registrationId;
  final DateTime? regDate;
  final String? customerVat;
  final String? dealerCode;
  final String? businessName;
  final String? parentCompany;
  final String? ownerName;
  final String? address;
  final String? contactNumber;
  final String? homeDelivery;
  final double? creditLimit;
  final int? paymentMethodId;
  final int? customerTypeId;
  final int? priceLevelId;
  final int? routeId;
  final int? employeeId;
  final double? depositBalance;
  final int? status;
  final Vat? vat;

  CustomerModel({
    this.customerId,
    this.registrationId,
    this.regDate,
    this.customerVat,
    this.dealerCode,
    this.businessName,
    this.parentCompany,
    this.ownerName,
    this.address,
    this.contactNumber,
    this.homeDelivery,
    this.creditLimit,
    this.paymentMethodId,
    this.customerTypeId,
    this.priceLevelId,
    this.routeId,
    this.employeeId,
    this.depositBalance,
    this.status,
    this.vat,
  });

  factory CustomerModel.fromJson(Map<dynamic, dynamic> json) => CustomerModel(
        customerId: json["customerId"],
        registrationId: json["registrationId"],
        regDate:
            json["regDate"] == null ? null : DateTime.parse(json["regDate"]),
        customerVat: json["customerVat"],
        dealerCode: json["dealerCode"],
        businessName: json["businessName"],
        parentCompany: json["parentCompany"],
        ownerName: json["ownerName"],
        address: json["address"],
        contactNumber: json["contactNumber"],
        homeDelivery: json["homeDelivery"],
        creditLimit: json["creditLimit"] is int
            ? json["creditLimit"]?.toDouble()
            : json["creditLimit"],
        paymentMethodId: json["paymentMethodId"],
        customerTypeId: json["customerTypeId"],
        priceLevelId: json["priceLevelId"],
        routeId: json["routeId"],
        employeeId: json["employeeId"],
        depositBalance: json["depositBalance"] is int
            ? json["depositBalance"]?.toDouble()
            : json["depositBalance"],
        status: json["status"],
        vat: json["vat"] != null ? Vat.fromJson(json["vat"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "registrationId": registrationId,
        "regDate":
            "${regDate!.year.toString().padLeft(4, '0')}-${regDate!.month.toString().padLeft(2, '0')}-${regDate!.day.toString().padLeft(2, '0')}",
        "customerVat": customerVat,
        "dealerCode": dealerCode,
        "businessName": businessName,
        "parentCompany": parentCompany,
        "ownerName": ownerName,
        "address": address,
        "contactNumber": contactNumber,
        "homeDelivery": homeDelivery,
        "creditLimit": creditLimit,
        "paymentMethodId": paymentMethodId,
        "customerTypeId": customerTypeId,
        "priceLevelId": priceLevelId,
        "routeId": routeId,
        "employeeId": employeeId,
        "depositBalance": depositBalance,
        "status": status,
        "vat": vat?.toJson(),
      };
}
