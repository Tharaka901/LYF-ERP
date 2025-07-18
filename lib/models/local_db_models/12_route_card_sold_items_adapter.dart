import 'package:hive/hive.dart';

import '../route_card_item/rc_sold_items_model.dart';

class RouteCardSoldItemsAdapter extends TypeAdapter<RouteCardSoldItemsModel> {
  @override
  final int typeId = 12;

  @override
  RouteCardSoldItemsModel read(BinaryReader reader) {
    return RouteCardSoldItemsModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, RouteCardSoldItemsModel obj) {
    writer.writeMap(obj.toJson());
  }
}