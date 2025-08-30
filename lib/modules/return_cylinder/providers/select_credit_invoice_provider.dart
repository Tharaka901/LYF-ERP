import 'package:flutter/material.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/issued_invoice_paid_model/issued_invoice_paid.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/invoice_service.dart';
import 'package:provider/provider.dart';

class SelectCreditInvoiceProvider extends ChangeNotifier {
  final invoiceService = InvoiceService();
  final paidAmountController = TextEditingController();
  List<InvoiceModel> creditInvoices = [];
  List<IssuedInvoicePaidModel> paidIssuedInvoices = [];
  InvoiceModel? selectedCreditInvoice;
  bool isLoading = false;

  double get totalInvoicePaymentAmount =>
      paidIssuedInvoices.fold(0, (sum, invoice) => sum + invoice.paymentAmount);

  Future<void> getCreditInvoices(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final response = await invoiceService.getCreditInvoices(context,
        cId: context.read<DataProvider>().selectedCustomer!.customerId,
        type: 'with-cheque');
    creditInvoices = response;
    isLoading = false;
    notifyListeners();
  }

  void setSelectCreditInvoice(InvoiceModel invoice) {
    selectedCreditInvoice = invoice;
    notifyListeners();
  }

  void setPaidAmount(String amount) {
    paidAmountController.text = amount;
    notifyListeners();
  }

  void addPaidIssuedInvoice() {
    paidIssuedInvoices.add(IssuedInvoicePaidModel(
      chequeId: selectedCreditInvoice!.chequeId,
      creditAmount: selectedCreditInvoice!.creditValue,
      issuedInvoice: selectedCreditInvoice!,
      paymentAmount:
          double.parse(paidAmountController.text.replaceAll(',', '')),
    ));
    notifyListeners();
  }

  void removePaidIssuedInvoice(IssuedInvoicePaidModel issuedInvoicePaid) {
    paidIssuedInvoices.remove(issuedInvoicePaid);
    notifyListeners();
  }

  void clearIssuedInvoices() {
    paidIssuedInvoices.clear();
  }
}
