import 'package:hive_flutter/hive_flutter.dart';

import '../models/local_db_models/0_employee_adapter.dart';
import '../models/local_db_models/1_route_card_adapter.dart';
import '../models/local_db_models/2_customer_adapter.dart';
import '../models/local_db_models/3_route_card_item_adapter.dart';
import '../models/local_db_models/4_invoice_adapter.dart';
import '../models/local_db_models/5_invoice_item_adapter.dart';
import '../models/local_db_models/6_customer_deposites_adapter.dart';
import '../models/local_db_models/7_customer_deposite_adapter.dart';
import '../models/local_db_models/8_payment_adapter.dart';
import '../models/local_db_models/9_issued_invoice_paid_adapter.dart';
import '../models/local_db_models/10_cheque_adapter.dart';
import '../models/local_db_models/11_credit_invoice_pay_from_deposites_data_adapter.dart';

registerHiveModels() async {
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
}
