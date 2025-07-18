import 'package:hive/hive.dart';

import '../route_card_item/rc_sold_loan_items_model.dart';

class RouteCardSoldLoanItemsAdapter
    extends TypeAdapter<RouteCardSoldLoanItemModel> {
  @override
  final int typeId = 13;

  @override
  RouteCardSoldLoanItemModel read(BinaryReader reader) {
    return RouteCardSoldLoanItemModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, RouteCardSoldLoanItemModel obj) {
    writer.writeMap(obj.toJson());
  }
}
