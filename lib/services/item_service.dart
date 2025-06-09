import '../commons/common_methods.dart';
import '../models/item/item_model.dart';
import '../models/route_card_item/route_card_item_model.dart';

class ItemService {
  Future<List<RouteCardItemModel>> getItemsByRoutecard(
      {required int routeCardId,
      required int priceLevelId,
      bool onlyDeposit = false,
      bool onlyRefill = true,
      String? type}) async {
    if (type == 'rc-summary') {
      final response =
          await respo('items/get-all-by-route-card?routecardId=$routeCardId');
      List<dynamic> list = response.data;

      return list
          .map((element) => RouteCardItemModel.fromJson(element))
          .toList();
    } else if (type == 'return') {
      List<RouteCardItemModel> returnItems = [];
      final response =
          await respo('items/get-return?priceLevelId=$priceLevelId');
      List<dynamic> list = response.data;
      for (var element in list) {
        final item = ItemModel.fromJson(element);
        returnItems.add(RouteCardItemModel(
          routecardItemsId: 0,
          itemId: item.id,
          transferQty: 1,
          sellQty: 0,
          routecardId: 0,
          status: 0,
          item: item,
        ));
      }
      return returnItems;
    }
    final response = await respo(
        'items/get-all-by-route-card?routecardId=$routeCardId&priceLevelId=$priceLevelId');
    List<dynamic> list = response.data ?? [];

    List<RouteCardItemModel> allItems = [];
    final items = onlyRefill
        ? list
            .map((element) => RouteCardItemModel.fromJson(element))
            .where((rci) => rci.item!.itemTypeId != 3)
            .toList()
        : onlyDeposit
            ? list
                .map((element) => RouteCardItemModel.fromJson(element))
                .where((rci) => rci.item!.itemTypeId == 3)
                .toList()
            : list
                .map((element) => RouteCardItemModel.fromJson(element))
                .toList();
    for (var element in items) {
      if (!(allItems.map((e) => e.item?.itemName).toList())
          .contains(element.item?.itemName)) {
        allItems.add(element);
      }
    }
    return allItems.where((element) => element.item?.itemTypeId != 5).toList();
  }

  Future<List<RouteCardItemModel>> getNewItems({
    required int routeCardId,
    required int priceLevelId,
  }) async {
    final refillItemsList = await getItemsByRoutecard(
      routeCardId: routeCardId,
      priceLevelId: priceLevelId,
      onlyRefill: true,
      onlyDeposit: false,
    );
    final newResponse = await respo(
        'items/get-new?priceLevelId=$priceLevelId&routecardId=$routeCardId');
    List<dynamic> newItemList = newResponse.data ?? [];
    List<RouteCardItemModel> rcNewItems = [];
    final response = await respo(
        'items/get-all-by-route-card?routecardId=$routeCardId&priceLevelId=$priceLevelId');
    List<dynamic> list = response.data ?? [];
    final list2 =
        list.map((element) => RouteCardItemModel.fromJson(element)).toList();
    for (var element in list2) {
      if (element.item?.itemTypeId == 3) {
        rcNewItems.add(element);
      }
    }
    for (var element in refillItemsList) {
      if (element.status == 2) {
        refillItemsList.add(element);
      }
    }
    for (var element in newItemList) {
      final item = ItemModel.fromJson(element);
      for (var element2 in refillItemsList) {
        if (item.itemName.replaceAll('Deposit', 'Refill') ==
            element2.item?.itemName) {
          rcNewItems.add(RouteCardItemModel(
            routecardItemsId: 0,
            itemId: item.id,
            transferQty: element2.transferQty,
            sellQty: 0,
            routecardId: 0,
            status: 0,
            item: item,
          ));
        }
      }
    }
    return rcNewItems;
  }
}
