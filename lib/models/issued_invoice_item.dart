// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'issued_invoice_item.g.dart';

@JsonSerializable()
class IssuedInvoiceItem {
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

  IssuedInvoiceItem({
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

  factory IssuedInvoiceItem.fromJson(Map<String, dynamic> json) => _$IssuedInvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$IssuedInvoiceItemToJson(this);
}
