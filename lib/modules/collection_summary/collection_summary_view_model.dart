import 'package:flutter/material.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/payment/payment_model.dart';
import 'package:gsr/models/payment_data/payment_data_model.dart';
import 'package:provider/provider.dart';

import '../../providers/hive_db_provider.dart';
import '../../services/payment_service.dart';

class CollectionSummaryViewModel {
  final paymentService = PaymentService();

  Future<List<PaymentModel>> getPayments(
      BuildContext context, int routecardId, int paymentMethod) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      return await paymentService.getPayments(context,
          routecardId: routecardId, paymentMethod: paymentMethod);
    } else {
      //! Get local DB payment data
      List<PaymentDataModel> payments =
          hiveDBProvider.paymentsBox?.values.toList() ?? [];

      return payments
          .map(
            (p) => PaymentModel(
              receiptNo: p.receiptNo,
              amount: p.cash,
              invoice: InvoiceModel(
                invoiceNo: p.invoiceNo ?? '',
                customer: CustomerModel(
                  registrationId: p.selectedCustomer.registrationId,
                  businessName: p.selectedCustomer.businessName,
                  depositBalance: p.selectedCustomer.depositBalance,
                ),
              ),
            ),
          )
          .toList();
    }
  }
}
