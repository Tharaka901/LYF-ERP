import 'package:flutter/material.dart';
import 'package:gsr/modules/invoice/invoice_view_model.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/invoice_service.dart';
import 'package:provider/provider.dart';

import '../../models/invoice.dart';
import '../../models/invoice_item.dart';
import '../../models/payment_data/payment_data_model.dart';
import '../../models/response.dart';
import '../../providers/hive_db_provider.dart';

class InvoiceProvider extends ChangeNotifier {
  final invoiceService = InvoiceService();
  final invoiceViewModel = InvoiceViewModel();
  String? invoiceNu;
  Respo? invoiceRes;

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
      ;
    }
    setCurrentInvoice(context);
  }

  //? onlyPayment = Only Credit invoice payment
  Future<void> createInvoiceDB(
    BuildContext context,
    String? invoiceNo, {
    bool? onlyPayment = false,
    PaymentDataModel? paymentDataModel,
  }) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      final invoiceRequest = invoiceViewModel.setInvoiceCreateRequest(context);
      invoiceRes = await invoiceService.createInvoice(invoiceRequest);
      //! Update local DB invoice number
      int invoiceCount = await invoiceService
          .invoiceCount(dataProvider.currentRouteCard!.routeCardId!);
      await hiveDBProvider.dataBox!.put(
        'invoiceCount',
        invoiceCount.toString(),
      );
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
      routecardId: dataProvider.currentRouteCard!.routeCardId!,
      amount: dataProvider.getTotalAmount(),
      customerId: dataProvider.selectedCustomer?.customerId ?? 0,
      employeeId: dataProvider.currentEmployee!.employeeId!,
    ));
  }
}
