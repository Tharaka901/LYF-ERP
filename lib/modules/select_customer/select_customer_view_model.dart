import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/services/customer_service.dart';
import 'package:provider/provider.dart';

import '../../providers/hive_db_provider.dart';

class SelectCustomerViewModel {
  final CustomerService customerService = CustomerService();

  FutureOr<List<CustomerModel>> onPressedSearchCustomerTextField(
      String pattern, BuildContext context) async {
    try {
      List<CustomerModel> customers = [];
      final hiveDBProvider =
          Provider.of<HiveDBProvider>(context, listen: false);

      if (hiveDBProvider.isInternetConnected) {
        // Online search - getCustomers now handles empty pattern

        customers = await customerService.getCustomers(pattern);
      } else {
        // Offline search from Hive database
        final allCustomers = hiveDBProvider.customersBox?.values.toList() ?? [];

        // If pattern is empty, return all customers
        if (pattern.trim().isEmpty) {
          customers = allCustomers;
        } else {
          // Filter customers based on search pattern
          customers = allCustomers
              .where((customer) =>
                  (customer.businessName != null &&
                      customer.businessName!
                          .toLowerCase()
                          .contains(pattern.toLowerCase())) ||
                  (customer.registrationId != null &&
                      customer.registrationId!
                          .toLowerCase()
                          .contains(pattern.toLowerCase())))
              .toList();
        }
      }

      return customers;
    } catch (e) {
      if (kDebugMode) {
        print('Error in customer search: $e');
      }
      return [];
    }
  }
}
