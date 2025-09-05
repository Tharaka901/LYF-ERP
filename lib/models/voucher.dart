// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable()
class VoucherModel {
  final int id;
  final String code;
  final double value;

  VoucherModel({
    required this.id,
    required this.code,
    required this.value,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}
