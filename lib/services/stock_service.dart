import '../commons/common_methods.dart';
import '../models/stock_item/stock_item_model.dart';

class StockService {
  Future<void> updateStock(List<StockItemModel> stockItems) async {
    try {
      await respo('stock/bulk-update',
          method: Method.post,
          data: {'stockItems': stockItems.map((e) => e.toJson()).toList()});
    } catch (e) {
      rethrow;
    }
  }
}
