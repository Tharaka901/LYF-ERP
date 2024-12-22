class PaymentMethodModel {
  final int? id;
  final String name;
  final String? amount;
  final String? chequeNu;

  PaymentMethodModel({
    required this.name,
    this.amount,
    this.chequeNu,
    this.id,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: json["paymentMethodId"],
        name: json["paymentMethod"],
      );

  Map<String, dynamic> toJson() => {
        "paymentMethodId": id,
        "paymentMethod": name,
      };
}
