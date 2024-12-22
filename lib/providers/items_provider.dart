import 'package:flutter/material.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';
import 'hive_db_provider.dart';

class ItemsProvider extends ChangeNotifier {
  List<dynamic> basicItems = [];
  List<dynamic> newItems = [];
  List<dynamic> otherItems = [];
  bool isLoadingItems = true;
  bool isViewNewItems = false;
  bool isViewOtherItems = false;

  Future<void> getBasicItems(BuildContext context) async {
    final _dataProvider = Provider.of<DataProvider>(context, listen: false);
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final routeCardId = _dataProvider.currentRouteCard!.routeCardId;
    final priceLevelId = _dataProvider.selectedCustomer?.priceLevelId ?? 0;

    if (hiveDBProvider.isInternetConnected) {
      basicItems = (await getItemsByRoutecard(
        routeCardId: routeCardId!,
        priceLevelId: priceLevelId,
        type: '',
      ))
          .where((element) => (element.transferQty - element.sellQty) != 0)
          .toList();

      final newItemsList = await getNewItems(
        routeCardId: routeCardId,
        priceLevelId: priceLevelId,
      );

      newItems = newItemsList.where((i) => i.item?.itemTypeId != 3).toList();
      otherItems = newItemsList.where((i) => i.item?.itemTypeId == 3).toList();
      isLoadingItems = false;
      notifyListeners();
    } else {
      basicItems =
          hiveDBProvider.routeCardBasicItemBox!.get(priceLevelId)!.toList();
      newItems =
          hiveDBProvider.routeCardNewItemBox!.get(priceLevelId)!.toList();
      otherItems =
          hiveDBProvider.routeCardOtherItemBox!.get(priceLevelId)!.toList();
      isLoadingItems = false;
    }
  }

  void onNewItemSwitchPressed() {
    isViewNewItems = !isViewNewItems;
    notifyListeners();
  }

  void onOtherItemSwitchPressed() {
    isViewOtherItems = !isViewOtherItems;
    notifyListeners();
  }

  void clearData() {
    basicItems.clear();
    newItems.clear();
    otherItems.clear();
    isLoadingItems = true;
    isViewNewItems = false;
    isViewOtherItems = false;
  }
}
