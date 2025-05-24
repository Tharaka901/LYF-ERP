import 'package:flutter/foundation.dart';

import '../commons/common_methods.dart';
import '../models/cash_settle/cash_settle.dart';
import '../models/route_card/route_card_model.dart';

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
}
