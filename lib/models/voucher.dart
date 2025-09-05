// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  final int id;
  final String code;
  final double value;

  Voucher({
    required this.id,
    required this.code,
    required this.value,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}
