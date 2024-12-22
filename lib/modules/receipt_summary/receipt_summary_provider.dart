import 'package:flutter/material.dart';
import 'package:gsr/models/credit_payment/credit_payment_model.dart';
import 'package:gsr/models/receipt/receipt_print_model.dart';

import '../../services/payment_service.dart';
import '../print/print_receipt_view.dart';
import 'receipt_summary_view_model.dart';

class ReceiptSummaryProvider extends ChangeNotifier {
  final PaymentService paymentService;
  final ReceiptSummaryViewModel receiptSummaryViewModel;
  ReceiptModel? receiptModel;

  ReceiptSummaryProvider({
    required this.receiptSummaryViewModel,
    required this.paymentService,
  });

  void onPressedPrintButton(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PrintReceiptView(receiptModel: receiptModel!)));
  }

  Future<void> getCreditPayments(
      BuildContext context, CreditPaymentModel creditPaymentModel) async {
    try {
      final payments = await paymentService.getCreditPayments(
          receiptNo: creditPaymentModel.receiptNo!);

      receiptModel = receiptSummaryViewModel.getReceiptModel(
          context, payments, creditPaymentModel);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
