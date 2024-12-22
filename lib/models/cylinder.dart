import 'dart:convert';

Cylinder cylinderFromJson(String str) => Cylinder.fromJson(json.decode(str));

String cylinderToJson(Cylinder data) => json.encode(data.toJson());

class Cylinder {
  final int? id;
  final String? leakInvoiceId;
  final String? routecardId;
  final int? customerId1;
  final int? itemId;
  final int? itemQty;
  final int? status;
  final String? cylinderNo;
  final String? referenceNo;

  Cylinder({
    this.id,
    this.leakInvoiceId,
    this.routecardId,
    this.customerId1,
    this.itemId,
    this.itemQty,
    this.status,
    this.cylinderNo,
    this.referenceNo,
  });

  factory Cylinder.fromJson(Map<String, dynamic> json) => Cylinder(
        id: json["id"],
        leakInvoiceId: json["leakInvoiceId"],
        routecardId: json["routecardId"],
        customerId1: json["customerId1"],
        itemId: json["itemId"],
        itemQty: json["itemQty"],
        status: json["status"],
        cylinderNo: json["cylinderNo"],
        referenceNo: json["referenceNo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leakInvoiceId": leakInvoiceId,
        "routecardId": routecardId,
        "customerId1": customerId1,
        "itemId": itemId,
        "itemQty": itemQty,
        "status": status,
        "cylinderNo": cylinderNo,
        "referenceNo": referenceNo,
      };
}
