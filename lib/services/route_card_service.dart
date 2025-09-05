import 'package:flutter/foundation.dart';

import '../commons/common_methods.dart';
import '../models/cash_settle/cash_settle.dart';
import '../models/item_summary_customer_wise/item_summary_customer_wise.dart';
import '../models/loan_stock/loan_stock.dart';
import '../models/route_card_item/rc_sold_items_model.dart';
import '../models/route_card/route_card_model.dart';
import '../models/route_card_item/rc_sold_loan_items_model.dart';
import '../models/route_card_item/route_card_item_model.dart';

class RouteCardService {
  Future<void> cashSettle(CashSettlementModel cashSettlement) async {
    try {
      await respo(
        'route-card/cash-save',
        method: Method.post,
        data: cashSettlement.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRouteCard({
    required int routeCardId,
    required int status,
  }) async {
    await respo('route-card/update', method: Method.post, data: {
      'routeCardId': routeCardId,
      'status': status,
    });
  }

  Future<List<RouteCardModel>> getPendingAndAcceptedRouteCards(int uid) async {
    try {
      final response = await respo(
        'route-card/get-by-uid/$uid?status=10',
      );
      List<dynamic> list = response.data;
      return list
          .map((element) => RouteCardModel.fromJson(element))
          .where((rc) => (rc.status == 0 || rc.status == 1))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<List<RouteCardItemModel>> getRouteCardItems(int routeCardId) async {
    try {
      final response = await respo(
        'route-card/$routeCardId/items',
      );
      List<dynamic> list = response.data;
      return list.map((e) => RouteCardItemModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<List<RouteCardSoldItemsModel>> getRouteCardSoldItems({
    required int routeCardId,
  }) async {
    try {
      final response = await respo('route-card/$routeCardId/sold-items');
      print(response.error);
      return (response.data as List)
          .map((i) => RouteCardSoldItemsModel.fromJson(i))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  Future<List<RouteCardSoldLoanItemModel>> getRouteCardSoldLoanItems(
      int routeCardId) async {
    try {
      final response = await respo(
        'route-card/$routeCardId/sold-loan-items',
      );
      List<dynamic> list = response.data;
      return list.map((e) => RouteCardSoldLoanItemModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<List<LoanStockModel>> getRouteCardSoldLeakItems(
      int routeCardId) async {
    try {
      final response = await respo('route-card/get-summary-with-leak-items',
          method: Method.post, data: {"routecardId": routeCardId});
      List<dynamic> list = response.data;
      return list.map((e) => LoanStockModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<List<ItemSummaryCustomerWise>>
      getReturnCylinderSummaryCustomerWiseLeak(int routeCardId,
          {bool isCustomerWise = true}) async {
    try {
      final response = await respo(
          'route-card/get-summary-return-cylinder-customer-wise',
          method: Method.post,
          data: {"routecardId": routeCardId, "isCustomerWise": isCustomerWise});
      List<dynamic> list = response.data ?? [];
      return list.map((e) => ItemSummaryCustomerWise.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
