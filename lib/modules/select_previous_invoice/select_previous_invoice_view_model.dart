import 'package:flutter/material.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/credit_invoice_pay_from_diposites/credit_invoice_pay_from_diposites_data_model.dart';
import '../../models/customer/customer_model.dart';
import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import 'select_previous_invoice_screen.dart';

class SelectPreviousInvoiceViewModel {
  final invoiceFormKey = GlobalKey<FormState>();
  final paymentService = PaymentService();

  //! Pay credit invoice from customer deposites
  Future<void> payFromDeposite(
      BuildContext context, TextEditingController paymentController) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    CreditInvoicePayFromDipositesDataModel creditInvoicePayFromDepositesData =
        CreditInvoicePayFromDipositesDataModel(
      depositeValue: dataProvider.selectedDeposite?.value ?? 0,
      payValue: double.parse(paymentController.text),
      customerId: dataProvider.selectedCustomer?.customerId ?? 0,
      paymentInvoiceId: dataProvider.selectedDeposite!.paymentInvoiceId!,
      customerDepositeValue: dataProvider.selectedCustomer?.depositBalance ?? 0,
      depositeStatus: dataProvider.selectedDeposite!.status!,
      depositeId: dataProvider.selectedDeposite!.id!,
      routeCardId: dataProvider.currentRouteCard!.routeCardId!,
      creditInvoiceId: dataProvider.selectedInvoice!.invoiceId!,
      depositeCreatedDate:
          dataProvider.selectedDeposite?.createdAt.toString() ?? '',
      crediteInvoiceValue: dataProvider.selectedInvoice!.creditValue!,
      chequeId: dataProvider.selectedInvoice!.chequeId,
      depositeReceiptNo: dataProvider.selectedDeposite!.receiptNo,
      // depositeReceiptNo: dataProvider.selectedDeposite?.status == 2
      //     ? dataProvider.selectedDeposite!.receiptNo
      //     : null,
    );

    if (hiveDBProvider.isInternetConnected) {
      final response = await respo('customers/get-by-reg-id',
          method: Method.post,
          data: {
            "registrationId": dataProvider.selectedCustomer?.registrationId
          });
      final customer = CustomerModel.fromJson(response.data);
      creditInvoicePayFromDepositesData.customerDepositeValue =
          customer.depositBalance ?? 0;
      await paymentService.payFromDeposite(creditInvoicePayFromDepositesData);
    } else {
      //! Save credit invoice pay from deposite values to local DB
      await hiveDBProvider.creditInvoicePayFromDepositesDataBox!.put(
          '${creditInvoicePayFromDepositesData.creditInvoiceId}-${creditInvoicePayFromDepositesData.depositeId}',
          creditInvoicePayFromDepositesData);
    }
    paymentController.clear();
    if (context.mounted) {
      pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SelectPreviousInvoiceScreen()));
    }
  }
}
