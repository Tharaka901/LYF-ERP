import '../commons/common_methods.dart';
import '../models/item/item_model.dart';

class ItemService {
  static Future<List<ItemModel>> getReturnCylinderItems(
      int priceLevelId) async {
    final response = await respo('items/get-return?priceLevelId=$priceLevelId');
    List<dynamic> list = response.data;
    return list.map((e) => ItemModel.fromJson(e)).toList();
  }
}
