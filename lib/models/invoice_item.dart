import 'package:gsr/models/item.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'invoice_item.g.dart';

@JsonSerializable()
class InvoiceItem {
  final Item item;
  final double itemPrice;
  final double itemQty;
  final int status;

  InvoiceItem({
    required this.item,
    required this.itemPrice,
    required this.itemQty,
    required this.status,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);
}
