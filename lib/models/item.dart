// ignore: depend_on_referenced_packages
import 'package:gsr/models/special_price.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int id;
  final String itemRegNo;
  String itemName;
  final double costPrice;
  double salePrice;
  final double? nonVatAmount;
  final double openingQty;
  final int vendorId;
  final int priceLevelId;
  final int itemTypeId;
  final int stockId;
  final int costAccId;
  final int incomeAccId;
  final int isNew;
  final SpecialPrice? hasSpecialPrice;
  final int status;
  late String? cylinderNo;
  late String? referenceNo;

  Item({
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
    this.hasSpecialPrice,
    required this.status,
    this.cylinderNo,
    this.referenceNo,
    this.nonVatAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
