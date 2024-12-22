import '../speceial_price/speceial_price_model.dart';

class ItemModel {
  final int? id;
  final String? itemRegNo;
  final String itemName;
  final double costPrice;
  double salePrice;
  final double? nonVatAmount;
  final double? openingQty;
  final int? vendorId;
  final int? priceLevelId;
  final int? itemTypeId;
  final int? stockId;
  final int? costAccId;
  final int? incomeAccId;
  final int? status;
  final int? isNew;
  final int? itemId;
  late String? cylinderNo;
  late String? referenceNo;
  final SpecialPriceModel? hasSpecialPrice;
  final ItemModel? item;
  final int? itemQty;
  final double? itemPrice;

  ItemModel({
    this.id,
    this.itemRegNo,
    required this.itemName,
    required this.costPrice,
    required this.salePrice,
    this.nonVatAmount,
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
    this.hasSpecialPrice,
    this.cylinderNo,
    this.referenceNo,
    this.item,
    this.itemQty,
    this.itemPrice,
  });

  factory ItemModel.fromJson(Map<dynamic, dynamic> json) => ItemModel(
        id: json["id"],
        itemRegNo: json["itemRegNo"],
        itemName: json["itemName"] ?? '',
        costPrice: ((json['costPrice'] ?? 0) as num).toDouble(),
        salePrice: ((json['salePrice']?? 0) as num).toDouble(),
        nonVatAmount: ((json['nonVatAmount'] ?? 0)as num).toDouble(),
        openingQty: ((json['openingQty']?? 0) as num).toDouble(),
        vendorId: json["vendorId"],
        priceLevelId: json["priceLevelId"],
        itemTypeId: json["itemTypeId"],
        stockId: json["stockId"],
        costAccId: json["costAccId"],
        incomeAccId: json["incomeAccId"],
        status: json["status"],
        isNew: json["isNew"],
        itemId: json["itemId"],
        item: json["item"] != null ? ItemModel.fromJson(json["item"]) : null ,
        itemQty: json["itemQty"],
        itemPrice: json["itemPrice"],
        hasSpecialPrice: json["hasSpecialPrice"] == null
            ? null
            : SpecialPriceModel.fromJson(json["hasSpecialPrice"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "itemRegNo": itemRegNo,
        "itemName": itemName,
        "costPrice": costPrice,
        "salePrice": salePrice,
        "nonVatAmount": nonVatAmount,
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
        "hasSpecialPrice": hasSpecialPrice?.toJson(),
      };
}
