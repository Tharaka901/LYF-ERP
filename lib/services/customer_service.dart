import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/customer/customer_model.dart';
import '../models/customer_deposite.dart';
import '../providers/data_provider.dart';

class CustomerService {
  Future<void> updateCustomer(
      {required int customerId, required double depositBalance}) async {
    await respo(
      'customers/update',
      method: Method.put,
      data: {
        "customerId": customerId,
        "depositBalance": depositBalance,
      },
    );
  }

  Future<List<CustomerModel>> getCustomers(String pattern,
      {int? routeId}) async {
    try {
      final response = await respo(
          'customers/get-all${routeId != null ? '?routeId=$routeId' : ''}');

      if (response.data == null) {
        return [];
      }

      List<dynamic> list = response.data;
      if (list.isEmpty) {
        return [];
      }

      List<CustomerModel> allCustomers =
          list.map((element) => CustomerModel.fromJson(element)).toList();

      // If pattern is empty, return all customers
      if (pattern.trim().isEmpty) {
        return allCustomers;
      }

      // If pattern is too short, return all customers
      if (pattern.trim().length < 2) {
        return allCustomers;
      }

      // Filter customers based on search pattern
      final filteredCustomers = allCustomers
          .where((element) =>
              (element.businessName != null &&
                  element.businessName!
                      .toLowerCase()
                      .contains(pattern.toLowerCase())) ||
              (element.registrationId != null &&
                  element.registrationId!
                      .toLowerCase()
                      .contains(pattern.toLowerCase())))
          .toList();

      return filteredCustomers;
    } catch (e) {
      if (kDebugMode) {
        print('Error in getCustomers: $e');
      }
      toast(
        'Connection error',
        toastState: TS.error,
      );
      return [];
    }
  }

  Future<List<CustomerDeposite>> getCustomerDeposites(BuildContext context,
      {int? cId, int? routecardId}) async {
    try {
      final response = await respo(
          'over-payment/get?customerId=${cId ?? context.read<DataProvider>().selectedCustomer!.customerId}&routecardId=$routecardId');
      List<dynamic> list = response.data;
      return list
          .where(
              (element) => (element['status'] == 1 || element['status'] == 2))
          .map((e) {
        return CustomerDeposite.fromJson(e);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  static Future<void> updateCustomerDepositBalance(
      {required BuildContext context,
      required int customerId,
      required double depositBalance}) async {
    await respo(
      'customers/update',
      method: Method.put,
      data: {"customerId": customerId, "depositBalance": depositBalance},
    );
  }
}
