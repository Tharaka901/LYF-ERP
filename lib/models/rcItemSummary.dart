class RcItemsSummary {
  int id;
  String name;
  String refill;
  String deposite;
  String empty;
  String total;
  String? returnRefillCount;
  String? returnEmptyCount;

  RcItemsSummary(
      {required this.id,
      required this.name,
      required this.refill,
      required this.deposite,
      required this.empty,
      required this.total,
      this.returnEmptyCount,
      this.returnRefillCount});

  factory RcItemsSummary.fromJson(Map<String, dynamic> json) => RcItemsSummary(
      id: json["id"],
      name: json["name"],
      refill: json["refill"],
      deposite: json["deposite"],
      empty: json["empty"],
      total: json["total"],
      returnRefillCount: json["returnRefillCount"],
      returnEmptyCount: json["returnEmptyCount"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "refill": refill,
        "deposite": deposite,
        "empty": empty,
        "total": total,
      };
}
