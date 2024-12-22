
import 'dart:convert';

ItemSummary itemSummaryFromJson(String str) =>
    ItemSummary.fromJson(json.decode(str));

String itemSummaryToJson(ItemSummary data) => json.encode(data.toJson());

class ItemSummary {
  final String? selQty;
  final int? itemId;
  final Invoice? invoice;
  final Item? item;

  ItemSummary({
    this.selQty,
    this.itemId,
    this.invoice,
    this.item,
  });

  factory ItemSummary.fromJson(Map<String, dynamic> json) => ItemSummary(
        selQty: json["selQty"],
        itemId: json["itemId"],
        invoice:
            json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "selQty": selQty,
        "itemId": itemId,
        "invoice": invoice?.toJson(),
        "item": item?.toJson(),
      };
}

class Invoice {
  final int? invoiceId;
  final String? invoiceNo;
  final int? routecardId;
  final double? amount;
  final int? customerId;
  final double? creditValue;
  final int? employeeId;
  final int? status;
  final DateTime? createdAt;

  Invoice({
    this.invoiceId,
    this.invoiceNo,
    this.routecardId,
    this.amount,
    this.customerId,
    this.creditValue,
    this.employeeId,
    this.status,
    this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceId: json["invoiceId"],
        invoiceNo: json["invoiceNo"],
        routecardId: json["routecardId"],
        amount: json["amount"]?.toDouble(),
        customerId: json["customerId"],
        creditValue: double.parse(json["creditValue"]),
        employeeId: json["employeeId"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "invoiceId": invoiceId,
        "invoiceNo": invoiceNo,
        "routecardId": routecardId,
        "amount": amount,
        "customerId": customerId,
        "creditValue": creditValue,
        "employeeId": employeeId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
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
        costPrice: json["costPrice"]?.toDouble(),
        salePrice: json["salePrice"]?.toDouble(),
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
