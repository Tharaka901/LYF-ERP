// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'payments.g.dart';

@JsonSerializable()
class Payments {
  final List<Map<String,dynamic>> payments;

  Payments({
    required this.payments,
  });

  factory Payments.fromJson(Map<String, dynamic> json) =>
      _$PaymentsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentsToJson(this);
}
