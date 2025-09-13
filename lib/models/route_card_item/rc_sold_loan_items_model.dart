import '../item/item_model.dart';

class RouteCardSoldLoanItemModel {
  final int itemId;
  final int issuedStock;
  final int receivedStock;
  final ItemModel item;

  RouteCardSoldLoanItemModel({
    required this.itemId,
    required this.issuedStock,
    required this.receivedStock,
    required this.item,
  });

  factory RouteCardSoldLoanItemModel.fromJson(Map<dynamic, dynamic> json) {
    return RouteCardSoldLoanItemModel(
      itemId: json['itemId'],
      issuedStock: (json['issuedStock'] as num).toInt(),
      receivedStock: (json['receivedStock'] as num).toInt(),
      item: ItemModel.fromJson(json['item']),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'itemId': itemId,
      'issuedStock': issuedStock,
      'receivedStock': receivedStock,
      'item': item.toJson(),
    };
  }
}
