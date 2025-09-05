import 'dart:convert';

LoanStockModel loanStockFromJson(String str) => LoanStockModel.fromJson(json.decode(str));

String loanStockToJson(LoanStockModel data) => json.encode(data.toJson());

class LoanStockModel {
  final String? selQty;
  final int? itemId;
  final Invoice? invoice;
  final Item? item;
  final int? status;

  LoanStockModel({
    this.selQty,
    this.itemId,
    this.invoice,
    this.item,
    this.status,
  });

  factory LoanStockModel.fromJson(Map<String, dynamic> json) => LoanStockModel(
        selQty: json["selQty"],
        itemId: json["itemId"],
        invoice:
            json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
        status: json["status"]
      );

  Map<String, dynamic> toJson() => {
        "selQty": selQty,
        "itemId": itemId,
        "invoice": invoice?.toJson(),
        "item": item?.toJson(),
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

  Invoice({
    this.id,
    this.invoiceNo,
    this.routecardId,
    this.customerId,
    this.employeeId,
    this.status,
    this.createdAt,
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNo": invoiceNo,
        "routecardId": routecardId,
        "customerId": customerId,
        "employeeId": employeeId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Item {
  final int? id;
  final String? itemRegNo;
  final String? itemName;
  final int? costPrice;
  final int? salePrice;
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
        costPrice: json["costPrice"],
        salePrice: json["salePrice"],
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

class LoanStockSummery {
  String? itemName;
  String? issuedStock;
  String? recivedStock;

  LoanStockSummery({this.issuedStock, this.itemName, this.recivedStock});
}
