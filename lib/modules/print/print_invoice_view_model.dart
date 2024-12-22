import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import '../issued_invoice_list/issued_invoice_list_view.dart';
import '../select_customer/select_customer_view.dart';

class PrintInvoiceViewModel {
  onPrinted(BuildContext context, final bool isBillingFrom) {
    if (isBillingFrom) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.issuedDepositePaidList.clear();
      dataProvider.chequeList.clear();
      dataProvider.issuedInvoicePaidList.clear();
      dataProvider.itemList.clear();
      Navigator.popUntil(
          context, ModalRoute.withName(SelectCustomerView.routeId));
    } else {
      Navigator.popUntil(
          context, ModalRoute.withName(IssuedInvoiceListView.routeId));
    }
  }
}
