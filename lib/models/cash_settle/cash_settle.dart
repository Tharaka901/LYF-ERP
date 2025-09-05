class CashSettlementModel {
  final int routecardId;
  final int? cash5000;
  final int? cash2000;
  final int? cash1000;
  final int? cash500;
  final int? cash200;
  final int? cash100;
  final int? cash50;
  final int? cash20;
  final int? cash10;
  final int? coins;
  final int? total;

  CashSettlementModel({
    required this.routecardId,
    this.cash5000,
    this.cash2000,
    this.cash1000,
    this.cash500,
    this.cash200,
    this.cash100,
    this.cash50,
    this.cash20,
    this.cash10,
    this.coins,
    this.total,
  });

  // Factory constructor to create an instance from JSON
  factory CashSettlementModel.fromJson(Map<String, dynamic> json) {
    return CashSettlementModel(
        cash5000: json['notes_5000'],
        cash2000: json['notes_2000'],
        cash1000: json['notes_1000'],
        cash500: json['notes_500'],
        cash200: json['notes_200'],
        cash100: json['notes_100'],
        cash50: json['notes_50'],
        cash20: json['notes_20'],
        cash10: json['notes_10'],
        routecardId: json["routecardId"]);
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'routecardId': routecardId,
      'notes_5000': cash5000,
      'notes_2000': cash2000,
      'notes_1000': cash1000,
      'notes_500': cash500,
      'notes_200': cash200,
      'notes_100': cash100,
      'notes_50': cash50,
      'notes_20': cash20,
      'notes_10': cash10,
      'coins': coins,
      'total': total
    };
  }
}
