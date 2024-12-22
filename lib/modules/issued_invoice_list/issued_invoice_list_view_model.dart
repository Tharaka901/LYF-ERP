import 'package:flutter/material.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/payment/payment_model.dart';
import 'package:provider/provider.dart';

import '../../providers/hive_db_provider.dart';
import '../../services/invoice_service.dart';

class IssuedInvoiceListViewModel {
  final invoiceService = InvoiceService();

  Future<List<InvoiceModel>> getIssuedInvoicess(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      return invoiceService.getIssuedInvoices(context);
    } else {
      List<InvoiceModel> _localIssuedInvoicesWithFullData = [];
      //!Get issued invoices from local DB
      final localIssuedInvoices = hiveDBProvider.invoiceBox!.values.toList();
      //! Set data to isued invoices
      localIssuedInvoices.forEach((invoice) {
        InvoiceModel invoiceData = invoice;
        final customer = hiveDBProvider.customersBox!.get(invoice.customerId);
        invoiceData.customer = customer;
        final _payments = hiveDBProvider.paymentsBox!.get(invoice.invoiceNo);
        invoiceData.previousPayments = [];
        invoiceData.payments = [];
        if (_payments != null) {
          if (_payments.cash != 0) {
            invoiceData.payments!.add(
              PaymentModel(
                receiptNo: _payments.receiptNo,
                amount: _payments.cash,
                paymentMethod: 1,
              ),
            );
          }
          if (_payments.chequeList.isNotEmpty) {
            invoiceData.payments!.addAll(
              _payments.chequeList.map(
                (c) => PaymentModel(
                  receiptNo: _payments.receiptNo,
                  amount: c.chequeAmount,
                  chequeNo: c.chequeNumber,
                  paymentMethod: 2,
                ),
              ),
            );
          }
        }
        _localIssuedInvoicesWithFullData.add(invoiceData);
      });
      return _localIssuedInvoicesWithFullData;
    }
  }
}
