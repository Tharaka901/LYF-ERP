import '../commons/common_methods.dart';
import '../models/cash_settle/cash_settle.dart';

class RouteCardService {
  Future<void> cashSettle(CashSettlementModel cashSettlement) async {
    try {
      print(cashSettlement.toJson());
      final t = await respo(
        'route-card/cash-save',
        method: Method.post,
        data: cashSettlement.toJson(),
      );
      print(t.error);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
