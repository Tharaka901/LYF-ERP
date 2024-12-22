// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'payment_methods.g.dart';

@JsonSerializable()
class PaymentMethod {
  final int paymentMethodId;
  final String paymentMethod;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethod,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
