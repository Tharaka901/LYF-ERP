import 'dart:convert';

CustomerDeposite customerDepositeFromJson(String str) =>
    CustomerDeposite.fromJson(json.decode(str));

String customerDepositeToJson(CustomerDeposite data) =>
    json.encode(data.toJson());

class CustomerDeposite {
  final int? id;
  final double? value;
  final int? status;
  final int? paymentInvoiceId;
  final int? routecardId;
  final String? receiptNo;
  final int? customerId;
  final DateTime? createdAt;

  CustomerDeposite({
    this.id,
    this.value,
    this.status,
    this.paymentInvoiceId,
    this.routecardId,
    this.receiptNo,
    this.customerId,
    this.createdAt,
  });

  factory CustomerDeposite.fromJson(Map<String, dynamic> json) =>
      CustomerDeposite(
        id: json["id"],
        value: double.parse(json["value"].toString()),
        status: json["status"],
        paymentInvoiceId: json["paymentInvoiceId"],
        routecardId: json["routecardId"],
        receiptNo: json["receiptNo"],
        customerId: json["customerId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "status": status,
        "paymentInvoiceId": paymentInvoiceId,
        "routecardId": routecardId,
        "receiptNo": receiptNo,
        "customerId": customerId,
        "createdAt": createdAt?.toIso8601String(),
      };
}
