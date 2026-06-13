import 'package:flutter/material.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/invoice_item/invoice_item_model.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../models/payment_data/payment_data_model.dart';
import '../../providers/data_provider.dart';
import 'invoice_provider.dart';

class InvoiceViewModel {
  /// Get current DateTime in Sri Lanka timezone (Asia/Colombo, UTC+5:30)
  /// Returns as UTC DateTime for proper database serialization
  DateTime _getSriLankaDateTime() {
    final sriLankaTime = tz.TZDateTime.now(tz.getLocation('Asia/Colombo'));
    // Convert TZDateTime to UTC DateTime for proper JSON serialization
    // This preserves the exact moment in time
    return sriLankaTime.toUtc();
  }

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
      vat: dataProvider.vat,
      nonVatItemTotal: dataProvider.nonVatItemTotal,
      customerId: selectedCustomer.customerId,
      creditValue: double.parse((dataProvider.grandTotal).toStringAsFixed(2)),
      employeeId: dataProvider.currentEmployee!.employeeId,
      rep: selectedCustomer.employeeId,
      status: 1,
      invoiceItems: setInvoiceItems(context),
      createdAt: _getSriLankaDateTime(),
    );
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
    final invoice = setInvoiceObject(context, invoiceNu: invoiceNu);
    return {
      "invoice": invoice.toJson(),
      "invoiceItems": setInvoiceItems(context)
    };
  }
}
