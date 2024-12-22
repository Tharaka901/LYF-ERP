import 'package:gsr/models/route_card/route_card_model.dart';

import '../commons/common_methods.dart';

class RouteCardService {
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
      print(e);
      rethrow;
    }
  }
}
