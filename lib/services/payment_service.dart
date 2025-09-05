import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/credit_payment.dart';
import '../providers/data_provider.dart';

class PaymentService {
  Future<String> getReceiptNumber(BuildContext context) async {
    final routeCard = context.read<DataProvider>().currentRouteCard!;
    final response = await respo('payment/count/?id=${routeCard.routeCardId}');
    final int count = response.data;
    return 'R/${routeCard.routeCardNo}/${count + 1}';
  }

  Future<List<CreditPayment>> getCreditPayments({
    required String receiptNo,
  }) async {
    final response = await respo('credit-payment/get?receiptNo=$receiptNo');
    List<dynamic> list = response.data;
    return list.map((element) => CreditPayment.fromJson(element)).toList();
  }

  Future<void> createCreditPayment(Map<String, dynamic> data) async {
    respo('credit-payment/create', method: Method.post, data: data);
  }

  Future<void> createOverPayment(
      {required double overPayment,
      required int paymentInvoiceId,
      required int routecardId,
      required String receiptNo,
      required int customerId}) async {
    await respo(
      'over-payment/create',
      method: Method.post,
      data: {
        "value": overPayment,
        "status": 2,
        "paymentInvoiceId": paymentInvoiceId,
        "routecardId": routecardId,
        "receiptNo": receiptNo,
        "customerId": customerId
      },
    );
  }
}
