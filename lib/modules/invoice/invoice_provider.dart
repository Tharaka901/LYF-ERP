import 'package:flutter/material.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../../models/invoice.dart';
import '../../models/invoice_item.dart';
import '../../models/response.dart';
import '../../models/route_card.dart';
import '../../services/invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceService invoiceService;

  InvoiceProvider({required this.invoiceService});

  String? invoiceNu;
  String? returnCylinderInvoiceNu;
  Respo? invoiceRes;
  bool iscreateReceipt = false; //! Create receipt and save other data to DB

  Future<void> getInvoiceNu(BuildContext context) async {
    // Ensure the context is mounted when used after an async gap
    if (!context.mounted) return;

    invoiceNu = await invoiceNumber(context);

    if (!context.mounted) return;
    setCurrentInvoice(context);
    notifyListeners();
  }

  Future<void> createInvoiceDB(BuildContext context, String? invoiceNo) async {
    iscreateReceipt = false;
    // Ensure the context is mounted when used after an async gap
    if (!context.mounted) return;

    invoiceRes =
        await createInvoice(context, invoiceNu: invoiceNo ?? invoiceNu);
  }

  void setCurrentInvoice(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.setCurrentInvoice(Invoice(
      invoiceItems: dataProvider.itemList
          .map(
            (addedItem) => InvoiceItem(
              item: addedItem.item,
              itemPrice: addedItem.item.hasSpecialPrice != null
                  ? addedItem.item.hasSpecialPrice!.itemPrice
                  : addedItem.item.salePrice,
              itemQty: addedItem.quantity,
              status: 1,
            ),
          )
          .toList(),
      invoiceNo: invoiceNu!,
      routecardId: dataProvider.currentRouteCard!.routeCardId,
      amount: dataProvider.getTotalAmount(),
      customerId: dataProvider.selectedCustomer?.customerId ?? 0,
      employeeId: dataProvider.currentEmployee!.employeeId!,
    ));
  }

  Future<void> getReturnCylinderInvoiceNumber(
      RouteCard routeCard, BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    returnCylinderInvoiceNu =
        await invoiceService.returnCylinderInvoiceNumber(routeCard);
    dataProvider.setCurrentInvoice(Invoice(
      invoiceItems: dataProvider.itemList
          .map(
            (addedItem) => InvoiceItem(
              item: addedItem.item,
              itemPrice: addedItem.item.hasSpecialPrice != null
                  ? addedItem.item.hasSpecialPrice!.itemPrice
                  : addedItem.item.salePrice,
              itemQty: addedItem.quantity,
              status: 1,
            ),
          )
          .toList(),
      invoiceNo: returnCylinderInvoiceNu!,
      routecardId: dataProvider.currentRouteCard!.routeCardId,
      amount: dataProvider.getTotalAmount(),
      customerId: dataProvider.selectedCustomer!.customerId ?? 0,
      employeeId: dataProvider.currentEmployee!.employeeId!,
    ));
    notifyListeners();
  }
}
