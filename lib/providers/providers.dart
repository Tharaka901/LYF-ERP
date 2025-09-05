import 'package:gsr/modules/return_cylinder/providers/return_cylinder_provider.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../commons/locator.dart';
import '../modules/home/home_provider.dart';
import '../modules/receipt_summary/receipt_summary_view_model.dart';
import '../services/invoice_service.dart';
import '../services/payment_service.dart';
import '../services/route_card_service.dart';
import 'data_provider.dart';
import 'hive_db_provider.dart';
import 'items_provider.dart';
import 'payment_provider.dart';
import '../modules/invoice/invoice_provider.dart';
import '../modules/receipt_summary/receipt_summary_provider.dart';
import '../modules/route_card/route_card_cash_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(
            create: (_) => HiveDBProvider()..checkConnection()),
        ChangeNotifierProvider(
            create: (_) =>
                HomeProvider(routeCardService: locator<RouteCardService>())),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ChangeNotifierProvider(create: (_) => RouteCardCashProvider()),
        ChangeNotifierProvider(
          create: (_) => ReceiptSummaryProvider(
            receiptSummaryViewModel: locator<ReceiptSummaryViewModel>(),
            paymentService: locator<PaymentService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(
            paymentService: locator<PaymentService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InvoiceProvider(
            invoiceService: locator<InvoiceService>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ReturnCylinderProvider()),
        ChangeNotifierProvider(create: (_) => SelectCreditInvoiceProvider()),
      ];
}
