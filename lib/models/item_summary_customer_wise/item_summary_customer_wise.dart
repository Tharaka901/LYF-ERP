import 'dart:convert';

ItemSummaryCustomerWise itemSummaryCustomerWiseFromJson(String str) =>
    ItemSummaryCustomerWise.fromJson(json.decode(str));

String itemSummaryCustomerWiseToJson(ItemSummaryCustomerWise data) =>
    json.encode(data.toJson());

class ItemSummaryCustomerWise {
  final String? selQty;
  final int? itemId;
  final Invoice? invoice;
  final Item? item;
  final int? status;
  final int? customerId1;

  ItemSummaryCustomerWise({
    this.selQty,
    this.itemId,
    this.invoice,
    this.item,
    this.status,
    this.customerId1,
  });

  factory ItemSummaryCustomerWise.fromJson(Map<String, dynamic> json) =>
      ItemSummaryCustomerWise(
        selQty: json["selQty"],
        itemId: json["itemId"],
        status: json["status"],
        customerId1: json["customerId1"],
        invoice:
            json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "selQty": selQty,
        "itemId": itemId,
        "invoice": invoice?.toJson(),
        "item": item?.toJson(),
        "customerId1": customerId1,
      };
}

class Invoice {
  final int? id;
  final String? invoiceNo;
  final int? routecardId;
  final int? customerId;
  final int? employeeId;
  final int? status;
  final DateTime? createdAt;
  final Customer? customer;

  Invoice({
    this.id,
    this.invoiceNo,
    this.routecardId,
    this.customerId,
    this.employeeId,
    this.status,
    this.createdAt,
    this.customer,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        invoiceNo: json["invoiceNo"],
        routecardId: json["routecardId"],
        customerId: json["customerId"],
        employeeId: json["employeeId"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNo": invoiceNo,
        "routecardId": routecardId,
        "customerId": customerId,
        "employeeId": employeeId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "customer": customer?.toJson(),
      };
}

class Customer {
  final int? customerId;
  final String? registrationId;
  final DateTime? regDate;
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

  Customer({
    this.customerId,
    this.registrationId,
    this.regDate,
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
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["customerId"],
        registrationId: json["registrationId"],
        regDate:
            json["regDate"] == null ? null : DateTime.parse(json["regDate"]),
        dealerCode: json["dealerCode"],
        businessName: json["businessName"],
        parentCompany: json["parentCompany"],
        ownerName: json["ownerName"],
        address: json["address"],
        contactNumber: json["contactNumber"],
        homeDelivery: json["homeDelivery"],
        creditLimit: double.parse(json["creditLimit"].toString()),
        paymentMethodId: json["paymentMethodId"],
        customerTypeId: json["customerTypeId"],
        priceLevelId: json["priceLevelId"],
        routeId: json["routeId"],
        employeeId: json["employeeId"],
        depositBalance:double.parse(json["depositBalance"].toString()), 
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "registrationId": registrationId,
        "regDate":
            "${regDate!.year.toString().padLeft(4, '0')}-${regDate!.month.toString().padLeft(2, '0')}-${regDate!.day.toString().padLeft(2, '0')}",
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
      };
}

class Item {
  final int? id;
  final String? itemRegNo;
  final String? itemName;
  final double? costPrice;
  final double? salePrice;
  final int? openingQty;
  final int? vendorId;
  final int? priceLevelId;
  final int? itemTypeId;
  final int? stockId;
  final int? costAccId;
  final int? incomeAccId;
  final int? status;
  final int? isNew;
  final int? itemId;

  Item({
    this.id,
    this.itemRegNo,
    this.itemName,
    this.costPrice,
    this.salePrice,
    this.openingQty,
    this.vendorId,
    this.priceLevelId,
    this.itemTypeId,
    this.stockId,
    this.costAccId,
    this.incomeAccId,
    this.status,
    this.isNew,
    this.itemId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        itemRegNo: json["itemRegNo"],
        itemName: json["itemName"],
        costPrice: double.parse(json["costPrice"].toString()),
        salePrice: double.parse(json["salePrice"].toString()),
        openingQty: json["openingQty"],
        vendorId: json["vendorId"],
        priceLevelId: json["priceLevelId"],
        itemTypeId: json["itemTypeId"],
        stockId: json["stockId"],
        costAccId: json["costAccId"],
        incomeAccId: json["incomeAccId"],
        status: json["status"],
        isNew: json["isNew"],
        itemId: json["itemId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemRegNo": itemRegNo,
        "itemName": itemName,
        "costPrice": costPrice,
        "salePrice": salePrice,
        "openingQty": openingQty,
        "vendorId": vendorId,
        "priceLevelId": priceLevelId,
        "itemTypeId": itemTypeId,
        "stockId": stockId,
        "costAccId": costAccId,
        "incomeAccId": incomeAccId,
        "status": status,
        "isNew": isNew,
        "itemId": itemId,
      };
}

class ItemSummaryCustomerWiseFull {
  String? customerName;
  String? itemName;
  int? issuedQty;
  int? recivedQty;
  String? unique;

  ItemSummaryCustomerWiseFull(
      {this.customerName,
      this.issuedQty,
      this.itemName,
      this.recivedQty,
      this.unique});
}
