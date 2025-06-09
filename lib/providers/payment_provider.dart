import 'package:flutter/material.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:provider/provider.dart';

import 'data_provider.dart';
import 'hive_db_provider.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;
  String? receiptNumber;

  PaymentProvider({required this.paymentService});

  Future<void> getReceiptNumber(BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      final receiptCount = await paymentService.getReceiptCount(context);
      int localDBReceiptCount = hiveDBProvider.dataBox!.length;
      receiptNumber =
          'R/${dataProvider.currentRouteCard!.routeCardNo}/${receiptCount + localDBReceiptCount + 1}';
      //!Save receipt count in local DB
      await hiveDBProvider.dataBox!
          .put('receiptCount', receiptCount.toString());
      notifyListeners();
    } else {
      int receiptCount =
          int.parse(hiveDBProvider.dataBox!.get('receiptCount') ?? '0');
      receiptNumber =
          'R/${dataProvider.currentRouteCard!.routeCardNo}/${receiptCount + 1}';
    }
  }
}
