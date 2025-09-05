import 'package:flutter/material.dart';
import 'package:gsr/models/payment_data/payment_data_model.dart';
import 'package:gsr/modules/invoice/invoice_provider.dart';
import 'package:gsr/providers/payment_provider.dart';
import 'package:gsr/services/invoice_service.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/invoice/invoice_model.dart';
import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import '../../services/customer_service.dart';

class InvoiceReceiptViewModel {
  final customerService = CustomerService();
  final invoiceService = InvoiceService();
  final paymentService = PaymentService();

  Future<List<dynamic>> getCustomerDeposites(BuildContext context,
      {int? cId, int? routecardId}) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      return customerService.getCustomerDeposites(context,
          cId: dataProvider.selectedCustomer!.customerId,
          routecardId: dataProvider.currentRouteCard?.routeCardId);
    } else {
      return (hiveDBProvider.customerDepositeBox!
              .get(dataProvider.selectedCustomer!.customerId)
              ?.deposits ??
          []);
    }
  }

  Future<List<InvoiceModel>> getCreditInvoices(BuildContext context,
      {int? cId, String? type, int? invoiceId}) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      return invoiceService.getCreditInvoices(context,
          cId: cId, type: type, invoiceId: invoiceId);
    } else {
      return List<InvoiceModel>.from(((hiveDBProvider.customerCreditBox!
                  .get(dataProvider.selectedCustomer!.customerId) ??
              [])
          .toList()));
    }
  }

  Future<void> pay({
    required BuildContext context,
    required double balance,
    required double cash,
    bool? isOnlySave,
    String? receiptNo,
    bool? isDirectPrevious = true,
  }) async {
    waiting(context, body: 'Sending...');
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final paymentprovider =
        Provider.of<PaymentProvider>(context, listen: false);
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    PaymentDataModel paymentDataModel = PaymentDataModel(
      selectedCustomer: dataProvider.selectedCustomer!,
      issuedInvoicePaidList: dataProvider.issuedInvoicePaidList,
      issuedDepositePaidList: dataProvider.issuedDepositePaidList,
      currentRouteCard: dataProvider.currentRouteCard!,
      balance: balance,
      receiptNo: receiptNo ?? paymentprovider.receiptNumber!,
      cash: cash,
      currentEmployee: dataProvider.currentEmployee!,
      chequeList: dataProvider.chequeList,
      selectedVoucher: dataProvider.selectedVoucher,
      invoiceId: invoiceProvider.invoiceRes?.data['invoice']['invoiceId'] ?? 0,
      totalPayment: dataProvider.getTotalChequeAmount() +
          cash +
          (dataProvider.selectedVoucher != null
              ? dataProvider.selectedVoucher!.value
              : 0.0),
      isDirectPrevoius: isDirectPrevious,
    );
    if (hiveDBProvider.isInternetConnected) {
      if (dataProvider.issuedInvoicePaidList.isNotEmpty && isDirectPrevious!) {
        await paymentService.payWithCreditInvoice(
          context: context,
          paymentDataModel: paymentDataModel,
        );
        //! only credit invoice payment
      } else if (!isDirectPrevious!) {
        await invoiceProvider.getInvoiceNu(context);
        paymentDataModel.invoiceNo = invoiceProvider.invoiceNu;
        await paymentService.sendCreditPayment(context, paymentDataModel);
      } else {
        await paymentService.pay(
          context: context,
          paymentDataModel: paymentDataModel,
          isOnlySave: isOnlySave,
        );
      }
      dataProvider.itemList.clear();
      dataProvider.issuedDepositePaidList.clear();
      dataProvider.issuedInvoicePaidList.clear();
    } else {
      //! Save payment data in local DB
      if (!isDirectPrevious!) {
        //! only credit invoice payment
        await invoiceProvider.getInvoiceNu(context);
        paymentDataModel.invoiceNo = invoiceProvider.invoiceNu;
        await invoiceProvider.createInvoiceDB(
          context,
          invoiceProvider.invoiceNu,
          paymentDataModel: paymentDataModel,
          onlyPayment: true,
        );
      }
      await hiveDBProvider.paymentsBox!
          .put(invoiceProvider.invoiceNu, paymentDataModel);
      //!Update receipt count
      int receiptCount =
          int.parse(hiveDBProvider.dataBox!.get('receiptCount') ?? '0');
      await hiveDBProvider.dataBox!
          .put('receiptCount', (receiptCount + 1).toString());
      dataProvider.itemList.clear();
      dataProvider.issuedDepositePaidList.clear();
      dataProvider.issuedInvoicePaidList.clear();
    }
  }
}
