
import 'package:gsr/models/route_card_item/route_card_item_model.dart';
import 'package:hive_flutter/adapters.dart';

class RouteCardItemAdapter extends TypeAdapter<RouteCardItemModel> {
  @override
  final typeId = 3;

  @override
  RouteCardItemModel read(BinaryReader reader) {
    return  RouteCardItemModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, RouteCardItemModel obj) {
    writer.writeMap(obj.toJson());
  }
}
