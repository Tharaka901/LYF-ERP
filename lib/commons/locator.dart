import 'package:get_it/get_it.dart';
import 'package:gsr/modules/receipt_summary/receipt_summary_view_model.dart';
import 'package:gsr/services/payment_service.dart';

import '../services/invoice_service.dart';
import '../services/route_card_service.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerSingleton<PaymentService>(PaymentService());
  locator.registerSingleton<InvoiceService>(InvoiceService());
  locator.registerSingleton<ReceiptSummaryViewModel>(ReceiptSummaryViewModel());
  locator.registerSingleton<RouteCardService>(RouteCardService());
}