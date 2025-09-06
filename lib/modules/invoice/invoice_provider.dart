import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../../models/invoice/invoice_model.dart';
import '../../models/invoice_item/invoice_item_model.dart';
import '../../models/payment_data/payment_data_model.dart';
import '../../models/response.dart';
import '../../models/route_card/route_card_model.dart';
import '../../providers/hive_db_provider.dart';
import '../../services/invoice_service.dart';
import 'invoice_view_model.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceService invoiceService;

  InvoiceProvider({required this.invoiceService});

  final invoiceViewModel = InvoiceViewModel();
  String? invoiceNu;
  String? returnCylinderInvoiceNu;
  Respo? invoiceRes;
  bool iscreateReceipt = false; //! Create receipt and save other data to DB

  Future<void> getInvoiceNu(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      int invoiceCount = await invoiceService
          .invoiceCount(dataProvider.currentRouteCard!.routeCardId!);
      int invoiceCountLocalDb = hiveDBProvider.invoiceBox!.length;
      invoiceNu =
          '${dataProvider.currentRouteCard!.routeCardNo}/${invoiceCount + invoiceCountLocalDb + 1}';
      //!Save invoice number in local DB
      await hiveDBProvider.dataBox!
          .put('invoiceCount', (invoiceCount + invoiceCountLocalDb).toString());
      notifyListeners();
    } else {
      int invoiceCount =
          int.parse(hiveDBProvider.dataBox!.get('invoiceCount') ?? '0');
      invoiceNu =
          '${dataProvider.currentRouteCard!.routeCardNo}/${invoiceCount + 1}';
    }
    if (context.mounted) {
      setCurrentInvoice(context);
    }
  }

  Future<void> createInvoiceDB(
    BuildContext context,
    String? invoiceNo, {
    bool? onlyPayment = false,
    PaymentDataModel? paymentDataModel,
  }) async {
    iscreateReceipt = false;
    // Ensure the context is mounted when used after an async gap
    if (!context.mounted) return;
    try {
      final hiveDBProvider =
          Provider.of<HiveDBProvider>(context, listen: false);
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      if (hiveDBProvider.isInternetConnected) {
        final invoiceRequest =
            invoiceViewModel.setInvoiceCreateRequest(context);
        invoiceRes = await invoiceService.createInvoice(invoiceRequest);
        //! Update local DB invoice number
        int serverCount = await invoiceService
            .invoiceCount(dataProvider.currentRouteCard!.routeCardId!);
        int localCount =
            int.parse(hiveDBProvider.dataBox!.get('invoiceCount') ?? '0');
        int maxCount = serverCount > localCount ? serverCount : localCount;
        await hiveDBProvider.dataBox!.put('invoiceCount', maxCount.toString());
      } else {
        //! Save invoice in local DB
        final invoice = invoiceViewModel.setInvoiceObject(context,
            onlyPayment: onlyPayment, paymentDataModel: paymentDataModel);
        await hiveDBProvider.invoiceBox!.put(invoiceNo ?? invoiceNu, invoice);
        //! Update local DB invoice number
        int invoiceCount =
            int.parse(hiveDBProvider.dataBox!.get('invoiceCount') ?? '0');
        await hiveDBProvider.dataBox!.put(
          'invoiceCount',
          (invoiceCount + 1).toString(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating invoice: $e');
      }
    }
  }

  void setCurrentInvoice(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.setCurrentInvoice(InvoiceModel(
      invoiceItems: dataProvider.itemList
          .map(
            (addedItem) => InvoiceItemModel(
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
      routecardId: dataProvider.currentRouteCard!.routeCardId!,
      amount: dataProvider.getTotalAmount(),
      customerId: dataProvider.selectedCustomer?.customerId ?? 0,
      employeeId: dataProvider.currentEmployee!.employeeId!,
    ));
  }

  Future<void> getReturnCylinderInvoiceNumber(
      RouteCardModel routeCard, BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    returnCylinderInvoiceNu =
        await invoiceService.returnCylinderInvoiceNumber(routeCard);
    dataProvider.setCurrentInvoice(InvoiceModel(
      invoiceItems: dataProvider.itemList
          .map(
            (addedItem) => InvoiceItemModel(
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
      routecardId: dataProvider.currentRouteCard!.routeCardId!,
      amount: dataProvider.getTotalAmount(),
      customerId: dataProvider.selectedCustomer!.customerId ?? 0,
      employeeId: dataProvider.currentEmployee!.employeeId!,
    ));
    notifyListeners();
  }
}
