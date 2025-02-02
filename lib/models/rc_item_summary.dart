class RcItemsSummary {
  int id;
  String name;
  int refill;
  int deposite;
  int empty;
  int freeEmpty;
  int leak;
  int damage;
  int free;
  int total;
  int loanIssued;
  int loanReceived;
  int? returnRefillCount;
  int? returnEmptyCount;

  RcItemsSummary(
      {required this.id,
      required this.name,
      required this.refill,
      required this.deposite,
      required this.empty,
      required this.freeEmpty,
      required this.leak,
      required this.damage,
      required this.free,
      required this.total,
      required this.loanIssued,
      required this.loanReceived,
      this.returnEmptyCount,
      this.returnRefillCount});

  factory RcItemsSummary.fromJson(Map<String, dynamic> json) => RcItemsSummary(
      id: json["id"],
      name: json["name"],
      refill: json["refill"],
      deposite: json["deposite"],
      empty: json["empty"],
      freeEmpty: json["freeEmpty"],
      leak: json["leak"],
      damage: json["damage"],
      free: json["free"],
      total: json["total"],
      loanIssued: json["loanIssued"],
      loanReceived: json["loanReceived"],
      returnRefillCount: json["returnRefillCount"],
      returnEmptyCount: json["returnEmptyCount"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "refill": refill,
        "deposite": deposite,
        "empty": empty,
        "freeEmpty": freeEmpty,
        "leak": leak,
        "damage": damage,
        "free": free,
        "total": total,
        "loanIssued": loanIssued,
        "loanReceived": loanReceived,
      };
}
