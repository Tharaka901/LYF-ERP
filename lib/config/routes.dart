import 'package:flutter/material.dart';
import '../screens/screens.dart';
import '../modules/invoice/invoice_view.dart';
import '../modules/view_receipt/invoice_receipt_screen.dart';
import '../modules/view_receipt/previous_view_receipt_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        AboutRCScreen.routeId: (context) => const AboutRCScreen(),
        AddItemsScreen.routeId: (context) => const AddItemsScreen(),
        AddPaymentScreen.routeId: (context) => const AddPaymentScreen(),
        SelectCustomerScreen.routeId: (context) => const SelectCustomerScreen(),
        CompletedRCScreen.routeId: (context) => const CompletedRCScreen(),
        InvoiceSummaryScreen.routeId: (context) => const InvoiceSummaryScreen(),
        HomeScreen.routeId: (context) => const HomeScreen(),
        LoginScreen.routeId: (context) => const LoginScreen(),
        OverallSummaryScreen.routeId: (context) => const OverallSummaryScreen(),
        PendingRCScreen.routeId: (context) => const PendingRCScreen(),
        PreviousAddPaymentScreen.routeId: (context) =>
            const PreviousAddPaymentScreen(),
        PreviousScreen.routeId: (context) => const PreviousScreen(),
        PreviousViewReceiptScreen.routeId: (context) =>
            const PreviousViewReceiptScreen(),
        RouteCardScreen.routeId: (context) => const RouteCardScreen(),
        ViewInvoiceScreen.routeId: (context) => const ViewInvoiceScreen(),
        InvoiceReceiptScreen.routeId: (context) => const InvoiceReceiptScreen(),
      };
}
