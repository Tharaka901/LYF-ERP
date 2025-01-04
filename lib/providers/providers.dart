import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../commons/locator.dart';
import '../modules/receipt_summary/receipt_summary_view_model.dart';
import '../services/payment_service.dart';
import 'data_provider.dart';
import 'items_provider.dart';
import 'payment_provider.dart';
import '../modules/invoice/invoice_provider.dart';
import '../modules/receipt_summary/receipt_summary_provider.dart';
import '../modules/route_card_cash/route_card_cash_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
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
      ];
}
