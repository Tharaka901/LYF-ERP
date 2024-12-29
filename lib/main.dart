import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/invoice/invoice_provider.dart';
import 'package:gsr/providers/items_provider.dart';
import 'package:gsr/screens/about_rc_screen.dart';
import 'package:gsr/screens/add_items_screen.dart';
import 'package:gsr/screens/add_payment_screen.dart';
import 'package:gsr/screens/select_customer_screen.dart';
import 'package:gsr/screens/completed_rc_screen.dart';
import 'package:gsr/screens/home_screen.dart';
import 'package:gsr/screens/invoice_summary_screen.dart';
import 'package:gsr/screens/login_screen.dart';
import 'package:gsr/screens/overall_summary_screen.dart';
import 'package:gsr/screens/pending_rc_screen.dart';
import 'package:gsr/screens/previous_add_payment_screen.dart';
import 'package:gsr/screens/previous_screen.dart';
import 'package:gsr/modules/view_receipt/previous_view_receipt_screen.dart';
import 'package:gsr/screens/route_card_screen.dart';
import 'package:gsr/screens/start_screen.dart';
import 'package:gsr/modules/invoice/invoice_view.dart';
import 'package:gsr/modules/view_receipt/invoice_receipt_screen.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:provider/provider.dart';

import 'commons/locator.dart';
import 'modules/receipt_summary/receipt_summary_provider.dart';
import 'modules/receipt_summary/receipt_summary_view_model.dart';
import 'modules/route_card_cash/route_card_cash_provider.dart';
import 'providers/payment_provider.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DataProvider()),
      ChangeNotifierProvider(create: (_) => ItemsProvider()),
      ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ChangeNotifierProvider(create: (_) => RouteCardCashProvider()),
      ChangeNotifierProvider(
          create: (_) => ReceiptSummaryProvider(
              receiptSummaryViewModel: locator<ReceiptSummaryViewModel>(),
              paymentService: locator<PaymentService>())),
      ChangeNotifierProvider(
          create: (_) =>
              PaymentProvider(paymentService: locator<PaymentService>())),
    ],
    child: const Main(),
  ));
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSR App',
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
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
        //RCSummaryScreen.routeId: (context) => const RCSummaryScreen(),
        RouteCardScreen.routeId: (context) => const RouteCardScreen(),
        // QRScanScreen.routeId: (context) => QRScanScreen(),
        ViewInvoiceScreen.routeId: (context) => const ViewInvoiceScreen(),
        InvoiceReceiptScreen.routeId: (context) => const InvoiceReceiptScreen(),
        //StockScreen.routeId: (context) => const StockScreen(),
      },
    );
  }
}
