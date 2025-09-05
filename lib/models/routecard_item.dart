import 'package:gsr/models/item.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'routecard_item.g.dart';

@JsonSerializable()
class RoutecardItem {
  final int routecardItemsId;
  final int itemId;
  final double transferQty;
  final double sellQty;
  final int routecardId;
  final int status;
  final Item? item;

  RoutecardItem({
    required this.routecardItemsId,
    required this.itemId,
    required this.transferQty,
    required this.sellQty,
    required this.routecardId,
    required this.status,
    this.item,
  });

  factory RoutecardItem.fromJson(Map<String, dynamic> json) =>
      _$RoutecardItemFromJson(json);

  Map<String, dynamic> toJson() => _$RoutecardItemToJson(this);
}
