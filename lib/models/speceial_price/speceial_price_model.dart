class SpecialPriceModel {
  final int? priceId;
  final int? itemId;
  final String? itemName;
  final double itemPrice;
  final double? nonVatAmount;
  final int? priceLevelId;
  final int? status;

  SpecialPriceModel({
    this.priceId,
    this.itemId,
    this.itemName,
    required this.itemPrice,
    this.nonVatAmount,
    this.priceLevelId,
    this.status,
  });

  factory SpecialPriceModel.fromJson(Map<dynamic, dynamic> json) =>
      SpecialPriceModel(
        priceId: json["priceId"],
        itemId: json["itemId"],
        itemName: json["itemName"],
        itemPrice: (json['itemPrice'] as num).toDouble(),
        nonVatAmount: (json['nonVatAmount'] as num).toDouble(),
        priceLevelId: json["priceLevelId"],
        status: json["status"],
      );

  Map<dynamic, dynamic> toJson() => {
        "priceId": priceId,
        "itemId": itemId,
        "itemName": itemName,
        "itemPrice": itemPrice,
        "nonVatAmount": nonVatAmount,
        "priceLevelId": priceLevelId,
        "status": status,
      };
}
