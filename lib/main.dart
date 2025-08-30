import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsr/models/local_db_models/10_cheque_adapter.dart';
import 'package:gsr/models/local_db_models/2_customer_adapter.dart';
import 'package:gsr/models/local_db_models/6_customer_deposites_adapter.dart';
import 'package:gsr/models/local_db_models/0_employee_adapter.dart';
import 'package:gsr/models/local_db_models/4_invoice_adapter.dart';
import 'package:gsr/models/local_db_models/5_invoice_item_adapter.dart';
import 'package:gsr/models/local_db_models/9_issued_invoice_paid_adapter.dart';
import 'package:gsr/models/local_db_models/8_payment_adapter.dart';
import 'package:gsr/models/local_db_models/1_route_card_adapter.dart';
import 'package:gsr/models/local_db_models/3_route_card_item_adapter.dart';
import 'package:gsr/modules/home/home_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/invoice/invoice_provider.dart';
import 'package:gsr/providers/items_provider.dart';
import 'package:gsr/screens/about_rc_screen.dart';
import 'package:gsr/screens/add_items_screen.dart';
import 'package:gsr/screens/add_payment_screen.dart';
import 'package:gsr/modules/select_customer/select_customer_view.dart';
import 'package:gsr/screens/completed_rc_screen.dart';
import 'package:gsr/modules/home/home_view.dart';
import 'package:gsr/modules/issued_invoice_list/issued_invoice_list_view.dart';
import 'package:gsr/screens/login_screen.dart';
import 'package:gsr/modules/collection_summary/collection_summary_screen.dart';
import 'package:gsr/screens/pending_rc_screen.dart';
import 'package:gsr/modules/previous_add_payment/previous_add_payment_screen.dart';
import 'package:gsr/modules/previous_customer_select/previous_screen.dart';
import 'package:gsr/modules/view_receipt/previous_view_receipt_screen.dart';
import 'package:gsr/screens/route_card_screen.dart';
import 'package:gsr/modules/start/start_view.dart';
import 'package:gsr/modules/invoice/invoice_view.dart';
import 'package:gsr/modules/view_receipt/invoice_receipt_screen.dart';
import 'package:gsr/services/payment_service.dart';
import 'package:gsr/services/route_card_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'commons/locator.dart';
import 'models/local_db_models/11_credit_invoice_pay_from_deposites_data_adapter.dart';
import 'models/local_db_models/7_customer_deposite_adapter.dart';
import 'modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'modules/return_cylinder/providers/return_cylinder_provider.dart';
import 'modules/receipt_summary/receipt_summary_provider.dart';
import 'modules/receipt_summary/receipt_summary_view_model.dart';
import 'providers/hive_db_provider.dart';
import 'providers/payment_provider.dart';

main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(RouteCardAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(RouteCardItemAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(InvoiceItemAdapter());
  Hive.registerAdapter(CustomerDepositesAdapter());
  Hive.registerAdapter(CustomerDepositeAdapter());
  Hive.registerAdapter(PaymentsAdapter());
  Hive.registerAdapter(IssuedInvoicePaidAdapter());
  Hive.registerAdapter(ChequeAdapter());
  Hive.registerAdapter(CreditInvoicePayFromDepositesDataAdapter());

  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => HiveDBProvider()..checkConnection()),
      ChangeNotifierProvider(
          create: (_) =>
              HomeProvider(routeCardService: locator<RouteCardService>())),
      ChangeNotifierProvider(create: (_) => DataProvider()),
      ChangeNotifierProvider(create: (_) => ItemsProvider()),
      ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ChangeNotifierProvider(
          create: (_) => ReceiptSummaryProvider(
              receiptSummaryViewModel: locator<ReceiptSummaryViewModel>(),
              paymentService: locator<PaymentService>())),
      ChangeNotifierProvider(
          create: (_) =>
              PaymentProvider(paymentService: locator<PaymentService>())),
      ChangeNotifierProvider(create: (_) => ReturnCylinderProvider()),
      ChangeNotifierProvider(create: (_) => SelectCreditInvoiceProvider()),
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
      home: const StartView(),
      debugShowCheckedModeBanner: false,
      routes: {
        AboutRCScreen.routeId: (context) => const AboutRCScreen(),
        AddItemsScreen.routeId: (context) => const AddItemsScreen(),
        AddPaymentScreen.routeId: (context) => const AddPaymentScreen(),
        SelectCustomerView.routeId: (context) => const SelectCustomerView(),
        CompletedRCScreen.routeId: (context) => const CompletedRCScreen(),
        IssuedInvoiceListView.routeId: (context) =>
            const IssuedInvoiceListView(),
        HomeScreen.routeId: (context) => const HomeScreen(),
        LoginScreen.routeId: (context) => const LoginScreen(),
        CollectionSummaryScreen.routeId: (context) =>
            const CollectionSummaryScreen(),
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
