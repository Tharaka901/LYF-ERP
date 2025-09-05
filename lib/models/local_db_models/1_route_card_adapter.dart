import 'package:gsr/models/route_card/route_card_model.dart';
import 'package:hive_flutter/adapters.dart';

class RouteCardAdapter extends TypeAdapter<RouteCardModel> {
  @override
  final typeId = 1;

  @override
  RouteCardModel read(BinaryReader reader) {
    return RouteCardModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, RouteCardModel obj) {
    writer.writeMap(obj.toJson());
  }
}
