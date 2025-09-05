class StockItemModel {
  final int itemId;
  final int quantity;

  StockItemModel({required this.itemId, required this.quantity});

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      itemId: json['item_id'],
      quantity: json['stock_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'stock_qty': quantity,
    };
  }
}
