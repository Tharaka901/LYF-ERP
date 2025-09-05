import 'package:flutter/material.dart';
import 'package:gsr/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;
  String? receiptNumber;

  PaymentProvider({required this.paymentService});

  Future<void> getReceiptNumber(BuildContext context) async {
    receiptNumber = await paymentService.getReceiptNumber(context);
    notifyListeners();
  }
}
