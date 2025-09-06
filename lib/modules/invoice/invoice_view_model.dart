import 'package:flutter/material.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/invoice_item/invoice_item_model.dart';
import 'package:provider/provider.dart';

import '../../models/payment_data/payment_data_model.dart';
import '../../providers/data_provider.dart';
import 'invoice_provider.dart';

class InvoiceViewModel {
  InvoiceModel setInvoiceObject(
    BuildContext context, {
    String? invoiceNu,
    bool? onlyPayment,
    PaymentDataModel? paymentDataModel,
  }) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;
    final invoiceNo = invoiceProvider.invoiceNu;
    return InvoiceModel(
        invoiceNo: invoiceNu ?? invoiceNo!,
        routecardId: dataProvider.currentRouteCard!.routeCardId,
        amount: (onlyPayment ?? false)
            ? paymentDataModel?.totalPayment
            : double.parse((dataProvider.grandTotal).toStringAsFixed(2)),
        subTotal:
            double.parse((dataProvider.getTotalAmount()).toStringAsFixed(2)),
        vat: double.parse(
            (((dataProvider.getTotalAmount() / 100) * 18)).toStringAsFixed(2)),
        nonVatItemTotal: dataProvider.nonVatItemTotal,
        customerId: selectedCustomer.customerId,
        creditValue: double.parse((dataProvider.grandTotal).toStringAsFixed(2)),
        employeeId: dataProvider.currentEmployee!.employeeId,
        status: 1,
        invoiceItems: setInvoiceItems(context),
        createdAt: DateTime.now());
  }

  List<InvoiceItemModel> setInvoiceItems(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return dataProvider.itemList
        .map((invoiceItem) => InvoiceItemModel(
              itemId: invoiceItem.item.id,
              itemPrice: invoiceItem.item.salePrice,
              itemQty: invoiceItem.quantity,
              status: invoiceItem.item.status,
              itemName: invoiceItem.item.itemName,
              routecardId: dataProvider.currentRouteCard!.routeCardId,
            ))
        .toList();
  }

  dynamic setInvoiceCreateRequest(BuildContext context, {String? invoiceNu}) {
    return {
      "invoice": setInvoiceObject(context, invoiceNu: invoiceNu),
      "invoiceItems": setInvoiceItems(context)
    };
  }
}
