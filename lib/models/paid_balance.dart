// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'balance.dart';

part 'paid_balance.g.dart';

@JsonSerializable()
class PaidBalance {
  final Balance balance;
  final double payment;

  PaidBalance({
    required this.balance,
    required this.payment,
  });

  factory PaidBalance.fromJson(Map<String, dynamic> json) =>
      _$PaidBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$PaidBalanceToJson(this);
}
