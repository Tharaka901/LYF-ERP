import 'package:flutter/material.dart';
import 'package:gsr/screens/screens.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../providers/data_provider.dart';
import '../../services/invoice_service.dart';
import '../print/loan_note_print_screen.dart';

class LoanCylinderViewModel {
  final BuildContext? context;
  final invoiceService = InvoiceService();

  LoanCylinderViewModel({this.context});

  void onPressedSaveButton() async {
    final dataProvider = Provider.of<DataProvider>(context!, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;

    waiting(context!, body: 'Sending...');
    await invoiceService.createLoanInvoice(
      routeCard: dataProvider.currentRouteCard!,
      customer: selectedCustomer,
      itemList: dataProvider.itemList,
      loanType: dataProvider.itemList[0].loanType,
      employee: dataProvider.currentEmployee!,
    );

    dataProvider.itemList.clear();
    if (context!.mounted) {
      pop(context!);
      Navigator.pushNamed(
        context!,
        RouteCardScreen.routeId,
      );
    }
  }

  Future<void> onPressedPrintButton() async {
    final dataProvider = Provider.of<DataProvider>(context!, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;

    waiting(context!, body: 'Sending...');
    await invoiceService.createLoanInvoice(
      routeCard: dataProvider.currentRouteCard!,
      customer: selectedCustomer,
      itemList: dataProvider.itemList,
      loanType: dataProvider.itemList[0].loanType,
      employee: dataProvider.currentEmployee!,
    );
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => const LoanNotePrintScreen(),
      ),
    );
  }

  void onPrintedButton() {
    final dataProvider = Provider.of<DataProvider>(context!, listen: false);
    dataProvider.itemList.clear();
    pop(context!);
    Navigator.pushNamed(
      context!,
      RouteCardScreen.routeId,
    );
  }
}
