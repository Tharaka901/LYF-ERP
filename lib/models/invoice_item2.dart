import 'package:gsr/models/item2.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'invoice_item2.g.dart';

@JsonSerializable()
class InvoiceItem2 {
  final Item2? item;
  final double itemPrice;
  final double itemQty;
  final int? status;

  InvoiceItem2({
    required this.item,
    required this.itemPrice,
    required this.itemQty,
    required this.status,
  });

  factory InvoiceItem2.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItem2FromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItem2ToJson(this);
}
