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
      if (kDebugMode) {
        print('ViewModel: Search pattern received: "$pattern"');
        print('ViewModel: Pattern length: ${pattern.length}');
        print('ViewModel: Pattern trimmed: "${pattern.trim()}"');
      }
      
      List<CustomerModel> customers = [];
      final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
      
      if (kDebugMode) {
        print('ViewModel: Internet connected: ${hiveDBProvider.isInternetConnected}');
      }
      
      if (hiveDBProvider.isInternetConnected) {
        // Online search - getCustomers now handles empty pattern
        if (kDebugMode) {
          print('ViewModel: Making online API call');
        }
        customers = await customerService.getCustomers(pattern);
        if (kDebugMode) {
          print('ViewModel: Online results count: ${customers.length}');
        }
      } else {
        // Offline search from Hive database
        final allCustomers = hiveDBProvider.customersBox?.values.toList() ?? [];
        if (kDebugMode) {
          print('ViewModel: Offline - total customers in Hive: ${allCustomers.length}');
        }
        
        // If pattern is empty, return all customers
        if (pattern.trim().isEmpty) {
          customers = allCustomers;
          if (kDebugMode) {
            print('ViewModel: Empty pattern - returning all customers');
          }
        } else {
          // Filter customers based on search pattern
          customers = allCustomers.where((customer) =>
              (customer.businessName != null && 
               customer.businessName!.toLowerCase().contains(pattern.toLowerCase())) ||
              (customer.registrationId != null && 
               customer.registrationId!.toLowerCase().contains(pattern.toLowerCase())))
              .toList();
          if (kDebugMode) {
            print('ViewModel: Filtered results count: ${customers.length}');
          }
        }
      }
      
      if (kDebugMode) {
        print('ViewModel: Final results count: ${customers.length}');
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
