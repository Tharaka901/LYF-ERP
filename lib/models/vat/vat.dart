class Vat {
  final int id;
  final String vatAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vat({
    required this.id,
    required this.vatAmount,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a Vat instance from JSON
  factory Vat.fromJson(Map<String, dynamic> json) {
    return Vat(
      id: json['id'] as int,
      vatAmount: json['vat_amount'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Method to convert a Vat instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vat_amount': vatAmount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
