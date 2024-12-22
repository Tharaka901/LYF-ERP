import 'dart:convert';

import '../item/item_model.dart';

RouteCardItemModel routeCardItemModelFromJson(String str) =>
    RouteCardItemModel.fromJson(json.decode(str));

String routeCardItemModelToJson(RouteCardItemModel data) =>
    json.encode(data.toJson());

class RouteCardItemModel {
  final int? routecardItemsId;
  final int? itemId;
  final double transferQty;
  final double sellQty;
  final int? routecardId;
  final int? status;
  final ItemModel? item;

  RouteCardItemModel({
    this.routecardItemsId,
    this.itemId,
    required this.transferQty,
    required this.sellQty,
    this.routecardId,
    this.status,
    this.item,
  });

  factory RouteCardItemModel.fromJson(Map<dynamic, dynamic> json) =>
      RouteCardItemModel(
        routecardItemsId: json["routecardItemsId"],
        itemId: json["itemId"],
        transferQty: (json['transferQty'] as num).toDouble(),
        sellQty: (json['sellQty'] as num).toDouble(),
        routecardId: json["routecardId"],
        status: json["status"],
        item: json["item"] == null ? null : ItemModel.fromJson(json["item"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "routecardItemsId": routecardItemsId,
        "itemId": itemId,
        "transferQty": transferQty,
        "sellQty": sellQty,
        "routecardId": routecardId,
        "status": status,
        "item": item!.toJson(),
      };
}
