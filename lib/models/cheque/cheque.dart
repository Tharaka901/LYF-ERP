class ChequeModel {
  final String chequeNumber;
  final double chequeAmount;

  ChequeModel({
    required this.chequeNumber,
    required this.chequeAmount,
  });

  factory ChequeModel.fromJson(Map<dynamic, dynamic> json) => ChequeModel(
      chequeAmount: json["chequeAmount"], chequeNumber: json["chequeNumber"]);

  Map<String, dynamic> toJson() =>
      {"chequeAmount": chequeAmount, "chequeNumber": chequeNumber};
}
