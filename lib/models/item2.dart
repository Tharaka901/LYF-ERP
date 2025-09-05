// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'item2.g.dart';

@JsonSerializable()
class Item2 {
  final int id;
  final String itemRegNo;
  final String itemName;
  final double costPrice;
  final double salePrice;
  final double openingQty;
  final int vendorId;
  final int priceLevelId;
  final int itemTypeId;
  final int stockId;
  final int costAccId;
  final int incomeAccId;
  final int isNew;
  final int status;

  Item2({
    required this.id,
    required this.itemRegNo,
    required this.itemName,
    required this.costPrice,
    required this.salePrice,
    required this.openingQty,
    required this.vendorId,
    required this.priceLevelId,
    required this.itemTypeId,
    required this.stockId,
    required this.costAccId,
    required this.incomeAccId,
    required this.isNew,
    required this.status,
  });

  factory Item2.fromJson(Map<String, dynamic> json) => _$Item2FromJson(json);

  Map<String, dynamic> toJson() => _$Item2ToJson(this);
}
