import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
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
  static const _invoiceCountKeyNonEntr = 'invoiceCount';
  static const _invoiceCountKeyEntr = 'invoiceCountEntr';

  Future<void> getInvoiceNu(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      final isEntrInvoice = dataProvider.selectedCustomer?.customerVat != "0";
      final allLocal = hiveDBProvider.invoiceBox?.values.toList() ?? [];
      final localEntrCount =
          allLocal.where((inv) => inv.invoiceNo.contains('ENTR')).length;
      final localNonEntrCount =
          allLocal.where((inv) => !inv.invoiceNo.contains('ENTR')).length;

      final serverCount = await invoiceService.invoiceCount(
        dataProvider.currentRouteCard!.routeCardId!,
        isProForma: isEntrInvoice,
      );

      if (!isEntrInvoice) {
        final base = serverCount + localNonEntrCount;
        invoiceNu =
            '${dataProvider.currentRouteCard!.routeCardNo}/${base + 1}';
        await hiveDBProvider.dataBox!.put(_invoiceCountKeyNonEntr, base.toString());
      } else {
        final base = serverCount + localEntrCount;
        invoiceNu = generateInvoiceNumber(
          referenceDate: dataProvider.currentRouteCard!.date!,
          invoiceCountBase: base,
        );
        await hiveDBProvider.dataBox!.put(_invoiceCountKeyEntr, base.toString());
      }
    } else {
      final isEntrInvoice = dataProvider.selectedCustomer?.customerVat != "0";
      final key = isEntrInvoice ? _invoiceCountKeyEntr : _invoiceCountKeyNonEntr;
      final base =
          int.tryParse(hiveDBProvider.dataBox!.get(key) ?? '0') ?? 0;
      if (!isEntrInvoice) {
        invoiceNu =
            '${dataProvider.currentRouteCard!.routeCardNo}/${base + 1}';
      } else {
        invoiceNu = generateInvoiceNumber(
          referenceDate: dataProvider.currentRouteCard!.date!,
          invoiceCountBase: base,
        );
      }
    }
    if (context.mounted) {
      setCurrentInvoice(context);
    }
    notifyListeners();
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
        if (invoiceNo != null) {
          invoiceNu = invoiceNo;
        }
        final invoiceRequest = invoiceViewModel.setInvoiceCreateRequest(context,
            invoiceNu: invoiceNo);
        invoiceRes = await invoiceService.createInvoice(invoiceRequest);
        //! Update local DB invoice number
        final isEntrInvoice = (invoiceNu ?? '').contains('ENTR') ||
            dataProvider.selectedCustomer?.customerVat != "0";
        final serverCount = await invoiceService.invoiceCount(
          dataProvider.currentRouteCard!.routeCardId!,
          isProForma: isEntrInvoice,
        );
        final key = isEntrInvoice ? _invoiceCountKeyEntr : _invoiceCountKeyNonEntr;
        final localCount = int.tryParse(hiveDBProvider.dataBox!.get(key) ?? '0') ?? 0;
        final maxCount = serverCount > localCount ? serverCount : localCount;
        await hiveDBProvider.dataBox!.put(key, maxCount.toString());
      } else {
        //! Save invoice in local DB
        if (invoiceNo != null) invoiceNu = invoiceNo;
        final invoice = invoiceViewModel.setInvoiceObject(context,
            onlyPayment: onlyPayment, paymentDataModel: paymentDataModel);
        await hiveDBProvider.invoiceBox!.put(invoiceNo ?? invoiceNu, invoice);
        //! Update local DB invoice number
        final isEntrInvoice = (invoiceNo ?? invoiceNu ?? '').contains('ENTR') ||
            dataProvider.selectedCustomer?.customerVat != "0";
        final key = isEntrInvoice ? _invoiceCountKeyEntr : _invoiceCountKeyNonEntr;
        int invoiceCount =
            int.tryParse(hiveDBProvider.dataBox!.get(key) ?? '0') ?? 0;
        await hiveDBProvider.dataBox!.put(
          key,
          (invoiceCount + 1).toString(),
        );
      }
    } catch (e) {
      toast(e.toString());
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
