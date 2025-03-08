import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../providers/data_provider.dart';
import '../../screens/route_card_screen.dart';
import '../../services/invoice_service.dart';
import '../print/leak_note_print_screen.dart';

class LeakInvoiceViewModel {
  final BuildContext context;
  LeakInvoiceViewModel({required this.context});

  final invoiceService = InvoiceService();

  void onPressedSaveButton() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    waiting(context, body: 'Sending...');
    await invoiceService.createLeakInvoice(
      routeCard: dataProvider.currentRouteCard!,
      customer: dataProvider.selectedCustomer!,
      itemList: dataProvider.itemList,
      selectedCylinderItemIds: dataProvider.selectedCylinderItemIds,
      employee: dataProvider.currentEmployee!,
      leakType: dataProvider.itemList[0].leakType,
      selectedCylinderList: dataProvider.selectedCylinderList,
    );
    dataProvider.itemList.clear();
    if (context.mounted) {
      pop(context);
      Navigator.pushNamed(
        context,
        RouteCardScreen.routeId,
      );
    }
  }

  void onPressedPrintButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeakNotePrintScreen()),
    );
  }
}
