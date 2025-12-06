import 'package:flutter/material.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:provider/provider.dart';
import 'hive_db_provider.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;
  String? receiptNumber;

  PaymentProvider({required this.paymentService});

  Future<void> getReceiptNumber(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    
    if (hiveDBProvider.isInternetConnected) {
      // Get receipt number from API when online
      receiptNumber = await paymentService.getReceiptNumberFromAPI(context);
    } else {
      // Get receipt number from local database when offline
      receiptNumber = await paymentService.getReceiptNumberFromLocal(context);
    }
    
    notifyListeners();
  }
}
