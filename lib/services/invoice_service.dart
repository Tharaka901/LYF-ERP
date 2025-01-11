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
}
