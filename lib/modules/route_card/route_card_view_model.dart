import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/stock_item/stock_item_model.dart';
import '../../providers/data_provider.dart';
import '../../services/route_card_service.dart';
import '../../services/stock_service.dart';
import '../print/route_card_print_screen.dart';

class RouteCardViewModel {
  RouteCardViewModel();

  final StockService stockService = StockService();
  final RouteCardService routeCardService = RouteCardService();

  Future<void> onPressedAcceptButton(BuildContext context) async {
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      waiting(context, body: 'Accepting Route Card...');
      await routeCardService.updateRouteCard(
        routeCardId: dataProvider.currentRouteCard!.routeCardId!,
        status: 1,
      );
      if (context.mounted) {
        pop(context);
        pop(context);
      }
      toast(
        'Routecard ${dataProvider.currentRouteCard!.routeCardNo} accepted successfully',
        toastState: TS.success,
      );
      dataProvider.acceptRouteCard();
    } catch (e) {
      toast(
        'Failed to accept Route Card',
        toastState: TS.error,
      );
    }
  }

  Future<void> onPressedAcceptAndPrintButton(BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RouteCardPrintScreen()));
  }

  Future<void> onPressedRejectButton(BuildContext context) async {
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final stockItems = dataProvider.rcItemList
          .map((e) => StockItemModel(
              itemId: e.item!.id!, quantity: e.transferQty.toInt()))
          .toList();
      waiting(context, body: 'Rejecting Route Card...');
      await stockService.updateStock(stockItems);
      await routeCardService.updateRouteCard(
        routeCardId: dataProvider.currentRouteCard!.routeCardId!,
        status: 4,
      );
      if (context.mounted) {
        pop(context);
        pop(context);
        pop(context);
      }
      toast(
        'Routecard ${dataProvider.currentRouteCard!.routeCardNo} rejected successfully',
        toastState: TS.success,
      );
      dataProvider.rejectRouteCard();
    } catch (e) {
      if (context.mounted) {
        pop(context);
        toast(
          'Failed to reject Route Card',
          toastState: TS.error,
        );
      }
    }
  }
}
