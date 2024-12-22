// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'balance2.g.dart';

@JsonSerializable()
class Balance2 {
  final int customerBalanceId;
  final double balanceAmount;

  Balance2({
    required this.customerBalanceId,
    required this.balanceAmount,
  });

  factory Balance2.fromJson(Map<String, dynamic> json) =>
      _$Balance2FromJson(json);

  Map<String, dynamic> toJson() => _$Balance2ToJson(this);
}
