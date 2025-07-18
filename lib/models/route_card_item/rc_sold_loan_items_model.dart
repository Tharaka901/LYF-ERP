import '../item/item_model.dart';

class RouteCardSoldLoanItemModel {
  final int itemId;
  final double issuedStock;
  final double receivedStock;
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
      issuedStock: (json['issuedStock'] as num).toDouble(),
      receivedStock: (json['receivedStock'] as num).toDouble(),
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
