import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/models/employee/employee_model.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/local_db_models/6_customer_deposites_adapter.dart';
import 'package:gsr/models/payment_data/payment_data_model.dart';
import 'package:gsr/models/route_card/route_card_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/credit_invoice_pay_from_diposites/credit_invoice_pay_from_diposites_data_model.dart';
import '../models/local_db_models/11_credit_invoice_pay_from_deposites_data_adapter.dart';

class HiveDBProvider extends ChangeNotifier {
  //! Hive boxes
  Box<String>? dataBox;
  Box<EmployeeModel>? employeeBox;
  Box<RouteCardModel>? routeCardBox;
  Box<CustomerModel>? customersBox;
  Box<List<dynamic>>? routeCardBasicItemBox;
  Box<List<dynamic>>? routeCardNewItemBox;
  Box<List<dynamic>>? routeCardOtherItemBox;
  Box<InvoiceModel>? invoiceBox;
  Box<CustomerDepositsModel>? customerDepositeBox;
  Box<List<dynamic>>? customerCreditBox;
  Box<PaymentDataModel>? paymentsBox;
  Box<CreditInvoicePayFromDipositesDataModel>?
      creditInvoicePayFromDepositesDataBox;

  SharedPreferences? sharedPreferences;
  bool isInternetConnected = true;

  //! Open hive boxes
  Future<void> openHiveBoxes() async {
    dataBox = await Hive.openBox<String>(HiveBox.data);
    employeeBox = await Hive.openBox<EmployeeModel>(HiveBox.employee);
    routeCardBox = await Hive.openBox<RouteCardModel>(HiveBox.routeCard);
    customersBox = await Hive.openBox<CustomerModel>(HiveBox.customers);
    invoiceBox = await Hive.openBox<InvoiceModel>(HiveBox.invoice);
    routeCardBasicItemBox =
        (await Hive.openBox<List<dynamic>>(HiveBox.routeCardBasicItems));
    routeCardNewItemBox =
        (await Hive.openBox<List<dynamic>>(HiveBox.routeCardNewItems));
    routeCardOtherItemBox =
        (await Hive.openBox<List<dynamic>>(HiveBox.routeCardOtherItems));
    customerDepositeBox =
        await Hive.openBox<CustomerDepositsModel>(HiveBox.customerDeposite);
    customerCreditBox =
        await Hive.openBox<List<dynamic>>(HiveBox.customerCredit);
    paymentsBox = await Hive.openBox<PaymentDataModel>(HiveBox.paymentBox);
    creditInvoicePayFromDepositesDataBox =
        await Hive.openBox(HiveBox.creditInvoicePayFromDepositesDataBox);

    sharedPreferences = await SharedPreferences.getInstance();
  }

  //! Check internet connection
  void checkConnection() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      print(status);
      isInternetConnected = status == InternetConnectionStatus.connected;
    });
  }
}
