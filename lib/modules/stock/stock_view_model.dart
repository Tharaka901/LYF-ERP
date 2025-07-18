import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/invoice_item/invoice_item_model.dart';
import '../../models/route_card_item/rc_sold_items_model.dart';
import '../../models/route_card_item/rc_sold_loan_items_model.dart';
import '../../models/route_card_item/route_card_item_model.dart';
import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import '../../services/route_card_service.dart';
import 'constants.dart';

class StockViewModel extends ChangeNotifier {
  final routeCardService = RouteCardService();

  bool isLoading = false;
  List<RouteCardItemModel> routeCardItems = [];
  List<RouteCardSoldItemsModel> routeCardSoldItems = [];
  List<RouteCardSoldLoanItemModel> routeCardSoldLoanItems = [];

  void loadStockData({required BuildContext context}) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCardId = dataProvider.currentRouteCard?.routeCardId ?? 0;
    isLoading = true;
    notifyListeners();
    //! Get route card items from the server or local DB
    routeCardItems = await getItemsByRoutecard(
        routeCardId: routeCardId, hiveDBProvider: hiveDBProvider);
    //! Get route card sold items from the server or local DB
    routeCardSoldItems = await getRouteCardSoldItems(
      routeCardId: routeCardId,
      hiveDBProvider: hiveDBProvider,
    );
    //! Get route card sold loan items from the server or local DB
    routeCardSoldLoanItems = await getRouteCardSoldLoanItems(
      routeCardId: routeCardId,
      hiveDBProvider: hiveDBProvider,
    );
    isLoading = false;
    notifyListeners();
  }

  Future<List<RouteCardItemModel>> getItemsByRoutecard({
    required int routeCardId,
    required HiveDBProvider hiveDBProvider,
  }) async {
    if (hiveDBProvider.isInternetConnected) {
      return await routeCardService.getRouteCardItems(
        routeCardId,
      );
    } else {
      final box = hiveDBProvider.routeCardIssuedItemsBox;
      final raw = box?.get(routeCardId);
      final List<RouteCardItemModel> items =
          (raw as List).map((e) => e as RouteCardItemModel).toList();
      return items;
    }
  }

  Future<List<RouteCardSoldItemsModel>> getRouteCardSoldItems({
    required int routeCardId,
    required HiveDBProvider hiveDBProvider,
  }) async {
    if (hiveDBProvider.isInternetConnected) {
      return await routeCardService.getRouteCardSoldItems(
          routeCardId: routeCardId);
    } else {
      final box = hiveDBProvider.routeCardSoldItemsBox;
      final raw = box?.get(routeCardId);
      final List<RouteCardSoldItemsModel> items =
          (raw as List).map((e) => e as RouteCardSoldItemsModel).toList();
      return items;
    }
  }

  Future<List<RouteCardSoldLoanItemModel>> getRouteCardSoldLoanItems({
    required int routeCardId,
    required HiveDBProvider hiveDBProvider,
  }) async {
    if (hiveDBProvider.isInternetConnected) {
      return await routeCardService.getRouteCardSoldLoanItems(routeCardId);
    } else {
      final box = hiveDBProvider.routeCardSoldItemsBox;
      final raw = box?.get(routeCardId);
      final List<RouteCardSoldLoanItemModel> items =
          (raw as List).map((e) => e as RouteCardSoldLoanItemModel).toList();
      return items;
    }
  }

  List<Map<String, dynamic>> getLocalDBSoldItems(
      List<InvoiceItemModel> combinedItems) {
    final List<Map<String, dynamic>> invoiceItemList = [];

    itemIdMap.forEach((key, map) {
      int parseQty(int? qty) => qty ?? 0;
      int getQty(int? id) {
        return id == null
            ? 0
            : combinedItems
                    .firstWhere((item) => item.itemId == id)
                    .itemQty
                    ?.toInt() ??
                0;
      }

      final refill = getQty(map['refill'] as int?);
      final empty = getQty(map['empty'] as int?);
      final freeEmpty = getQty(map['freeEmpty'] as int?);
      final free = getQty(map['free'] as int?);
      final deposite = getQty(map['deposite'] as int?);
      final leak = getQty(map['leak'] as int?);
      final damage = getQty(map['damage'] as int?);

      // final loanReceived = combinedItems
      //     .firstWhere(
      //       (item) => item.itemId == map['loan'] && item.invoice.status == 2,
      //       orElse: () => Item(
      //           itemId: -1,
      //           selQty: '0',
      //           invoice: Invoice(status: 0, invoiceNo: '')),
      //     )
      //     .selQty;

      // final loanIssued = combinedItems
      //     .firstWhere(
      //       (item) => item.itemId == map['loan'] && item.invoice.status == 3,
      //       orElse: () => Item(
      //           itemId: -1,
      //           selQty: '0',
      //           invoice: Invoice(status: 0, invoiceNo: '')),
      //     )
      //     .selQty;

      // final returnCylinderFull = combinedItems
      //     .firstWhere(
      //       (item) =>
      //           item.itemId == map['refill'] &&
      //           item.invoice.invoiceNo.contains('GRN/RCN') &&
      //           ![25, 26, 27, 28].contains(item.itemId),
      //       orElse: () => Item(
      //           itemId: -1,
      //           selQty: '0',
      //           invoice: Invoice(status: 0, invoiceNo: '')),
      //     )
      //     .selQty;

      // final returnCylinderEmpty = combinedItems
      //     .firstWhere(
      //       (item) =>
      //           item.itemId == map['empty'] &&
      //           item.invoice.invoiceNo.contains('GRN/RCN') &&
      //           [25, 26, 27, 28].contains(item.itemId),
      //       orElse: () => Item(
      //           itemId: -1,
      //           selQty: '0',
      //           invoice: Invoice(status: 0, invoiceNo: '')),
      //     )
      //     .selQty;

      invoiceItemList.add({
        'id': map['refill'],
        'name': map['name'],
        'refill': parseQty(refill),
        'empty': parseQty(empty),
        'freeEmpty': parseQty(freeEmpty),
        'deposite': parseQty(deposite),
        'leak': parseQty(leak),
        'damage': parseQty(damage),
        'free': parseQty(free),
        // 'loanReceived': parseQty(loanReceived),
        // 'loanIssued': parseQty(loanIssued),
        // 'returnCylinderFull': parseQty(returnCylinderFull),
        // 'returnCylinderEmpty': parseQty(returnCylinderEmpty),
        'total': parseQty(refill) +
            parseQty(empty) +
            parseQty(freeEmpty) +
            parseQty(deposite) +
            parseQty(leak) +
            parseQty(damage) +
            parseQty(free),
      });
    });

    return invoiceItemList;
  }
}
