// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'special_price.g.dart';

@JsonSerializable()
class SpecialPrice {
  final int priceId;
  final double itemPrice;
  final int status;
  final double? nonVatAmount;

  SpecialPrice({
    required this.priceId,
    required this.itemPrice,
    required this.status,
    this.nonVatAmount,
  });

  factory SpecialPrice.fromJson(Map<String, dynamic> json) =>
      _$SpecialPriceFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialPriceToJson(this);
}
