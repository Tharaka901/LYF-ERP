import 'package:gsr/models/item/item_model.dart';

class InvoiceItemModel {
  final int? itemId;
  final double? itemPrice;
  final double? itemQty;
  final int? status;
  final int? routecardId;
  final String? itemName;
  ItemModel? item;

  InvoiceItemModel({
    this.itemId,
    this.itemPrice,
    this.itemQty,
    this.status,
    this.routecardId,
    this.itemName,
    this.item,
  });

  factory InvoiceItemModel.fromJson(Map<dynamic, dynamic> json) =>
      InvoiceItemModel(
        itemId: json["itemId"],
        itemPrice: json["itemPrice"] is int
            ? json["itemPrice"].toDouble()
            : json["itemPrice"],
        itemQty: json["itemQty"] is int
            ? json["itemQty"].toDouble()
            : json["itemQty"],
        status: json["status"],
        routecardId: json["routecardId"],
        itemName: json["itemName"],
        item: json["item"],
      );

  Map<dynamic, dynamic> toJson() => {
        "itemId": itemId,
        "itemPrice": itemPrice,
        "itemQty": itemQty,
        "status": status,
        "routecardId": routecardId,
        "itemName": itemName,
      };
}
