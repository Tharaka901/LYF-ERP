import 'package:flutter/material.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:provider/provider.dart';

import '../../models/credit_payment/credit_payment_model.dart';
import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';

class ReceiptListViewModel {
  final paymentService = PaymentService();

  Future<List<CreditPaymentModel>> getCreditPayments(
      BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      return paymentService.getCreditPayments(
          routecardId: dataProvider.currentRouteCard!.routeCardId!);
    } else {
      return [];
    }
  }
}
