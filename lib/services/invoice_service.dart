import 'package:gsr/models/route_card.dart';

import '../commons/common_methods.dart';

class InvoiceService {
  Future<String> invoiceNumber(RouteCard routeCard) async {
    final response =
        await respo('invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> returnCylinderInvoiceNumber(RouteCard routeCard) async {
    final response = await respo(
        'return-cylinder-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<void> updateInvoice(
      int invoiceId, int status, double creditValue) async {
    respo('invoice/update', method: Method.put, data: {
      "invoiceId": invoiceId,
      "status": status,
      "creditValue": creditValue
    });
  }

  Future<void> updateCheque(
      {required int chequeId, required double balance, int? isActive}) async {
    final data = {"id": chequeId, "balance": balance};
    if (isActive != null) {
      data["isActive"] = isActive;
    }
    respo('cheque/update', method: Method.put, data: data);
  }
}
