import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/services/customer_service.dart';
import 'package:provider/provider.dart';

import '../../providers/hive_db_provider.dart';

class SelectCustomerViewModel {
  final CustomerService customerService = CustomerService();

  FutureOr<List<CustomerModel>> onPressedSearchCustomerTextField(
      String pattern, BuildContext context) async {
    List<CustomerModel>? customers;
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);    
    if (hiveDBProvider.isInternetConnected) {
      customers = await customerService.getCustomers(pattern);
    } else {
      customers = hiveDBProvider.customersBox?.values.toList() ?? [];
    }
    return customers;
  }
}
