import 'package:flutter/material.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/customer_deposite.dart';
import '../providers/data_provider.dart';

class CustomerService {
  Future<List<CustomerModel>> getCustomers(String pattern,
      {int? routeId}) async {
    try {
      final response = await respo(
          'customers/get-all${routeId != null ? '?routeId=$routeId' : ''}');
      List<dynamic> list = response.data;
      return list
          .map((element) => CustomerModel.fromJson(element))
          .where((element) =>
              element.businessName
                  .toLowerCase()
                  .contains(pattern.toLowerCase()) ||
              element.registrationId
                  .toLowerCase()
                  .contains(pattern.toLowerCase()))
          .toList();
    } on Exception {
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
