import 'package:flutter/material.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/screens/screens.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/response.dart';
import '../../models/route_card.dart';
import '../../providers/data_provider.dart';
import '../../services/customer_service.dart';
import '../../services/invoice_service.dart';
import '../../services/payment_service.dart';
import '../print/print_return_note_view.dart';

class ReturnCylinderViewModel {
  InvoiceService invoiceService = InvoiceService();
  PaymentService paymentService = PaymentService();
  CustomerService customerService = CustomerService();

  late DataProvider dataProvider;
  late RouteCard routeCard;
  late CustomerModel selectedCustomer;
  final BuildContext context;

  ReturnCylinderViewModel(this.context) {
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    routeCard = dataProvider.currentRouteCard!;
    selectedCustomer = dataProvider.selectedCustomer!;
  }

  void onPressedSaveButton() async {
    final checkoutTotal = dataProvider.grandTotal;
    final overPayment =
        checkoutTotal - dataProvider.getTotalInvoicePaymentAmount();

    if (overPayment >= 0) {
      waiting(context, body: 'Sending...');
      final invoiceRes = await _createReturnCylinderInvoice(context);

      for (var invoice in dataProvider.issuedInvoicePaidList) {
        if (invoice.creditAmount! <= invoice.paymentAmount &&
            invoice.chequeId == null) {
          await invoiceService.updateInvoice(
              invoice.issuedInvoice.invoiceId!, 2, 0);
        } else {
          await invoiceService.updateInvoice(invoice.issuedInvoice.invoiceId!,
              1, invoice.creditAmount! - invoice.paymentAmount);
        }
        if (invoice.chequeId != null) {
          if (invoice.creditAmount! <= invoice.paymentAmount) {
            await invoiceService.updateCheque(
                chequeId: invoice.chequeId!, balance: 0, isActive: 2);
          } else {
            await invoiceService.updateCheque(
                chequeId: invoice.chequeId!,
                balance: invoice.creditAmount! - invoice.paymentAmount);
          }
        }
        final paymentData = {
          "value": invoice.paymentAmount,
          "paymentInvoiceId": invoiceRes.data["invoice"]["id"],
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "creditInvoiceId":
              invoice.chequeId ?? invoice.issuedInvoice.invoiceId,
          "receiptNo": invoiceRes.data["invoice"]["invoiceNo"],
          "status": 4, //invoice.chequeId != null ? 3 : 2,
          "type": "return-cheque"
        };
        await paymentService.createCreditPayment(paymentData);
      }
      if (overPayment > 0) {
        await customerService.updateCustomer(
          customerId: selectedCustomer.customerId!,
          depositBalance: selectedCustomer.depositBalance! + overPayment,
        );
        await paymentService.createOverPayment(
          overPayment: overPayment,
          paymentInvoiceId: invoiceRes.data["invoice"]["id"],
          routecardId: dataProvider.currentRouteCard!.routeCardId,
          receiptNo: invoiceRes.data["invoice"]["invoiceNo"],
          customerId: selectedCustomer.customerId!,
        );
      }
      dataProvider.itemList.clear();
      dataProvider.issuedInvoicePaidList.clear();
      if (context.mounted) {
        pop(context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteCardScreen.routeId, (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SelectCustomerScreen(
                    type: 'Return',
                  )),
        ).then((value) {
          dataProvider.clearItemList();
          dataProvider.clearChequeList();
          dataProvider.clearRCItems();
          dataProvider.clearPaidBalanceList();
          dataProvider.setSelectedCustomer(null);
          dataProvider.setSelectedVoucher(null);
          dataProvider.setCurrentInvoice(null);
        });
        toast('Success', toastState: TS.success);
      } else {
        toast('Please set total payment $checkoutTotal', toastState: TS.error);
      }
    }
  }

  void onPressedPrintButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrintReturnNoteView()),
    );
  }

  Future<Respo> _createReturnCylinderInvoice(BuildContext context) async {
    try {
      final invoiceNo =
          await invoiceService.returnCylinderInvoiceNumber(routeCard);
      //! Create invoice
      final invoiceResponse = await respo(
        'return-cylinder-invoice/create',
        method: Method.post,
        data: {
          "invoice": {
            "invoiceNo": 'GRN/$invoiceNo',
            "routecardId": dataProvider.currentRouteCard!.routeCardId,
            "customerId": selectedCustomer.customerId,
            "employeeId": dataProvider.currentEmployee!.employeeId,
            "status": dataProvider.itemList
                            .map((e) => e.item.salePrice * e.quantity)
                            .reduce((value, element) => value + element) -
                        dataProvider.getTotalInvoicePaymentAmount() ==
                    0
                ? 2
                : 1,
            "withoutVat": dataProvider.getTotalAmount(),
            "vatAmount": dataProvider.vat,
            "total": dataProvider.grandTotal,
            "balance": (dataProvider.grandTotal -
                    dataProvider.getTotalInvoicePaymentAmount())
                .toStringAsFixed(2)
          },
          "invoiceItems": dataProvider.itemList
              .map((invoiceItem) => {
                    "itemId": invoiceItem.item.id,
                    "itemQty": invoiceItem.quantity,
                    "routecardId": dataProvider.currentRouteCard!.routeCardId,
                    "customerId1": selectedCustomer.customerId,
                  })
              .toList()
        },
      );
      return invoiceResponse;
    } catch (e) {
      toast(e.toString());
      rethrow;
    }
  }
}
