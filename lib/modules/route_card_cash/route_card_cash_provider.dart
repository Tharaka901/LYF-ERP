import 'package:flutter/material.dart';
import 'package:gsr/models/cash_settle/cash_settle.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import '../../services/route_card_service.dart';

class RouteCardCashProvider extends ChangeNotifier {
  final routeCardService = RouteCardService();

  int totalCash = 0;

  final TextEditingController cash5000Controller =
      TextEditingController(text: '0');
  final TextEditingController cash2000Controller =
      TextEditingController(text: '0');
  final TextEditingController cash1000Controller =
      TextEditingController(text: '0');
  final TextEditingController cash500Controller =
      TextEditingController(text: '0');
  final TextEditingController cash200Controller =
      TextEditingController(text: '0');
  final TextEditingController cash100Controller =
      TextEditingController(text: '0');
  final TextEditingController cash50Controller =
      TextEditingController(text: '0');
  final TextEditingController cash20Controller =
      TextEditingController(text: '0');
  final TextEditingController cash10Controller =
      TextEditingController(text: '0');
  final TextEditingController coinController = TextEditingController(text: '0');

  void addCashListeners() {
    cash5000Controller.addListener(calculateTotalCash);
    cash2000Controller.addListener(calculateTotalCash);
    cash1000Controller.addListener(calculateTotalCash);
    cash500Controller.addListener(calculateTotalCash);
    cash200Controller.addListener(calculateTotalCash);
    cash100Controller.addListener(calculateTotalCash);
    cash50Controller.addListener(calculateTotalCash);
    cash20Controller.addListener(calculateTotalCash);
    cash10Controller.addListener(calculateTotalCash);
    coinController.addListener(calculateTotalCash);
  }

  void disposeListeners() {
    cash5000Controller.dispose();
    cash2000Controller.dispose();
    cash1000Controller.dispose();
    cash500Controller.dispose();
    cash200Controller.dispose();
    cash100Controller.dispose();
    cash50Controller.dispose();
    cash20Controller.dispose();
    cash10Controller.dispose();
    coinController.dispose();
  }

  void clearValues() {
    cash5000Controller.clear();
    cash2000Controller.clear();
    cash1000Controller.clear();
    cash500Controller.clear();
    cash200Controller.clear();
    cash100Controller.clear();
    cash50Controller.clear();
    cash20Controller.clear();
    cash10Controller.clear();
    coinController.clear();
  }

  void calculateTotalCash() {
    totalCash = int.parse(cash5000Controller.text) * 5000 +
        int.parse(cash2000Controller.text) * 2000 +
        int.parse(cash1000Controller.text) * 1000 +
        int.parse(cash500Controller.text) * 500 +
        int.parse(cash200Controller.text) * 200 +
        int.parse(cash100Controller.text) * 100 +
        int.parse(cash50Controller.text) * 50 +
        int.parse(cash20Controller.text) * 20 +
        int.parse(cash10Controller.text) * 10 +
        int.parse(coinController.text);
    notifyListeners();
  }

  Future<void> completeRC(BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final cashSettlementModel = CashSettlementModel(
      routecardId: dataProvider.currentRouteCard!.routeCardId,
      cash5000: int.parse(cash5000Controller.text),
      cash2000: int.parse(cash2000Controller.text),
      cash1000: int.parse(cash1000Controller.text),
      cash500: int.parse(cash500Controller.text),
      cash200: int.parse(cash200Controller.text),
      cash100: int.parse(cash100Controller.text),
      cash50: int.parse(cash50Controller.text),
      cash20: int.parse(cash20Controller.text),
      cash10: int.parse(cash10Controller.text),
      coins: int.parse(coinController.text),
      total: totalCash,
    );
    await routeCardService.cashSettle(cashSettlementModel);
    clearValues();
  }
}
