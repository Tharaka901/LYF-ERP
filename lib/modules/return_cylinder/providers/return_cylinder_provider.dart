import 'package:flutter/material.dart';
import 'package:gsr/modules/select_customer/select_customer_screen.dart';
import 'package:gsr/models/item/item_model.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/model/request/credit_payment_request.dart';
import 'package:gsr/modules/return_cylinder/model/request/over_payment_request.dart';
import 'package:gsr/modules/return_cylinder/model/request/return_cylinder_request.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:gsr/modules/return_cylinder/services/cheque_service.dart';
import 'package:gsr/modules/return_cylinder/services/return_cylinder_service.dart';
import 'package:gsr/screens/route_card_screen.dart';
import 'package:gsr/services/credit_payment_service.dart';
import 'package:gsr/services/over_payment_service.dart';
import 'package:gsr/services/customer_service.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

class ReturnCylinderProvider extends ChangeNotifier {
  List<ItemModel> selectedItems = [];
  String returnCylinderInvoiceNumber = '';

  double get totalPrice => selectedItems
      .map((e) => e.salePrice * e.itemQty!)
      .reduce((value, element) => value + element);
  double get nonVatAmount => selectedItems
      .map((e) => e.nonVatAmount! * e.itemQty!)
      .reduce((value, element) => value + element);

  void addSelectedItem(ItemModel item) {
    if (selectedItems.any((element) => element.id == item.id)) {
      toast('Item already added', toastState: TS.error);
      return;
    }
    selectedItems.add(item);
    notifyListeners();
  }

  void removeSelectedItem(ItemModel item) {
    selectedItems.remove(item);
    notifyListeners();
  }

  void clearSelectedItems() {
    selectedItems.clear();
    notifyListeners();
  }

  void updateItemQuantity(ItemModel item) {
    // Find the item in the list and update it
    final index = selectedItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      selectedItems[index] = item;
      notifyListeners();
    }
  }

  void getReturnCylinderInvoiceNumber(BuildContext context) async {
    returnCylinderInvoiceNumber =
        await ReturnCylinderService.returnCylinderInvoiceNumber(context);
    notifyListeners();
  }

  void saveReturnCylinderData(BuildContext context) async {
    final selectCreditInvoiceProvider =
        Provider.of<SelectCreditInvoiceProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    if (totalPrice >= selectCreditInvoiceProvider.totalInvoicePaymentAmount) {
      waiting(context, body: 'Sending...');
      try {
        //! Create request return cylinder invoice
        final requestReturnCylinderInvoice = ReturnCylinderInvoiceRequest(
          invoice: ReturnCylinderInvoice(
            invoiceNo: 'GRN/$returnCylinderInvoiceNumber',
            routecardId: dataProvider.currentRouteCard!.routeCardId!,
            customerId: dataProvider.selectedCustomer!.customerId!,
            employeeId: dataProvider.currentEmployee!.employeeId!,
            status: totalPrice -
                        selectCreditInvoiceProvider.totalInvoicePaymentAmount ==
                    0
                ? 2
                : 1,
            total: totalPrice,
            vatAmount:
                double.parse((totalPrice - nonVatAmount).toStringAsFixed(2)),
            withoutVat: nonVatAmount,
            balance: (totalPrice -
                    selectCreditInvoiceProvider.totalInvoicePaymentAmount)
                .toStringAsFixed(2),
          ),
          invoiceItems: selectedItems
              .map((item) => ReturnCylinderInvoiceItem(
                    itemId: item.id!,
                    itemQty: item.itemQty!,
                    routecardId: dataProvider.currentRouteCard!.routeCardId!,
                    customerId1: dataProvider.selectedCustomer!.customerId!,
                    price: item.salePrice,
                    nonVatAmount: item.nonVatAmount!,
                  ))
              .toList(),
        );
        final invoiceRes =
            await ReturnCylinderService.createReturnCylinderInvoice(
                requestReturnCylinderInvoice);
        //! Update credit invoice status
        for (var invoice in selectCreditInvoiceProvider.paidIssuedInvoices) {
          if (invoice.chequeId != null) {
            await ChequeService.updateChequeStatus(
                chequeId: invoice.chequeId!,
                status: invoice.creditAmount! <= invoice.paymentAmount ? 2 : 1,
                balance: invoice.creditAmount! - invoice.paymentAmount);
          } else {
            await ReturnCylinderService.updateCreditInvoiceStatus(
                invoiceId: invoice.issuedInvoice.invoiceId!,
                status: invoice.creditAmount! <= invoice.paymentAmount ? 2 : 1,
                creditValue: invoice.creditAmount! - invoice.paymentAmount);
          }

          //! Create credit payment
          final request = ReturnCylinderCreditInvoicePaymentRequest(
            value: invoice.paymentAmount,
            paymentInvoiceId: invoiceRes.data["invoice"]["id"],
            routecardId: dataProvider.currentRouteCard!.routeCardId!,
            creditInvoiceId: invoice.chequeId != null
                ? invoice.chequeId!
                : invoice.issuedInvoice.invoiceId!,
            receiptNo: invoiceRes.data["invoice"]["invoiceNo"],
            status: 4,
            type: "return-cheque",
          );
          await CreditPaymentService.createCreditPayment(request);
        }

        if (totalPrice - selectCreditInvoiceProvider.totalInvoicePaymentAmount >
            0) {
          //! Update customer deposit balance
          if (context.mounted) {
            await CustomerService.updateCustomerDepositBalance(
                context: context,
                customerId: dataProvider.selectedCustomer!.customerId!,
                depositBalance: dataProvider.selectedCustomer!.depositBalance! +
                    (totalPrice -
                        selectCreditInvoiceProvider.totalInvoicePaymentAmount));
          }

          //! Create over payment
          final request = ReturnCylinderOverPaymentRequest(
            routecardId: dataProvider.currentRouteCard!.routeCardId!,
            receiptNo: invoiceRes.data["invoice"]["invoiceNo"],
            customerId: dataProvider.selectedCustomer!.customerId!,
            value: (totalPrice -
                    selectCreditInvoiceProvider.totalInvoicePaymentAmount)
                .toStringAsFixed(2),
            status: 2,
            paymentInvoiceId: invoiceRes.data["invoice"]["id"],
          );
          await OverPaymentService.createOverPayment(request);
        }
        if (context.mounted) {
          pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteCardScreen.routeId, (route) => false);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SelectCustomerView(type: 'Return')),
          ).then((value) {
            clearSelectedItems();
            returnCylinderInvoiceNumber = '';
            selectCreditInvoiceProvider.clearIssuedInvoices();
            dataProvider.setSelectedCustomer(null);
            dataProvider.setSelectedVoucher(null);
            dataProvider.setCurrentInvoice(null);
          });
        }
        toast('Success', toastState: TS.success);
      } catch (e) {
        toast(e.toString(), toastState: TS.error);
        rethrow;
      }
    }
  }
}
