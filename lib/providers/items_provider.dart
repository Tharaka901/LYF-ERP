import 'package:flutter/material.dart';
import 'package:gsr/models/routecard_item.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class ItemsProvider extends ChangeNotifier {
  List<RoutecardItem> basicItems = [];
  List<RoutecardItem> newItems = [];
  List<RoutecardItem> otherItems = [];
  bool isLoadingItems = true;
  bool isViewNewItems = false;
  bool isViewOtherItems = false;

  Future<void> getBasicItems(BuildContext context) async {
    final _dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCardId = _dataProvider.currentRouteCard!.routeCardId;
    final priceLevelId = _dataProvider.selectedCustomer?.priceLevelId ?? 0;

    basicItems = (await getItemsByRoutecard(
      routeCardId: routeCardId,
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
