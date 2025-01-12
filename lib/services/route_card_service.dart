import '../commons/common_methods.dart';
import '../models/cash_settle/cash_settle.dart';

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
}
