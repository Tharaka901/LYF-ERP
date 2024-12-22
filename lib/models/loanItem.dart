import 'dart:convert';

LoanItem loanItemFromJson(String str) => LoanItem.fromJson(json.decode(str));

String loanItemToJson(LoanItem data) => json.encode(data.toJson());

class LoanItem {
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
  final CardItem? cardItem;

  LoanItem({
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
    this.cardItem,
  });

  factory LoanItem.fromJson(Map<String, dynamic> json) => LoanItem(
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
        cardItem: json["cardItem"] == null
            ? null
            : CardItem.fromJson(json["cardItem"]),
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
        "cardItem": cardItem?.toJson(),
      };
}

class CardItem {
  final int? routecardItemsId;
  final int? itemId;
  final int? transferQty;
  final int? sellQty;
  final int? routecardId;
  final int? status;

  CardItem({
    this.routecardItemsId,
    this.itemId,
    this.transferQty,
    this.sellQty,
    this.routecardId,
    this.status,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) => CardItem(
        routecardItemsId: json["routecardItemsId"],
        itemId: json["itemId"],
        transferQty: json["transferQty"],
        sellQty: json["sellQty"],
        routecardId: json["routecardId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "routecardItemsId": routecardItemsId,
        "itemId": itemId,
        "transferQty": transferQty,
        "sellQty": sellQty,
        "routecardId": routecardId,
        "status": status,
      };
}
