import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import '../../screens/invoice_summary_screen.dart';
import '../../screens/route_card_screen.dart';
import '../select_customer/select_customer_screen.dart';

class PrintInvoiceViewModel {
  onPrinted(BuildContext context, final bool isBillingFrom) {
    if (isBillingFrom) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.issuedDepositePaidList.clear();
      dataProvider.chequeList.clear();
      dataProvider.issuedInvoicePaidList.clear();
      dataProvider.itemList.clear();
      dataProvider.setSelectedCustomer(null);
      Navigator.popUntil(
        context,
        ModalRoute.withName(RouteCardScreen.routeId),
      );
      Navigator.pushNamed(
        context,
        SelectCustomerScreen.routeId,
        arguments: {
          //  'route_card': routeCard,
        },
      );
    } else {
      Navigator.popUntil(
          context, ModalRoute.withName(InvoiceSummaryScreen.routeId));
    }
  }
}
