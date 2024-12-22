import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/services/customer_service.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import '../../services/database.dart';

class SelectCustomerViewModel {
  final CustomerService customerService = CustomerService();

  FutureOr<List<CustomerModel>> onPressedSearchCustomerTextField(
      String pattern, BuildContext context) async {
    List<CustomerModel>? customers;
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final _dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCardId = _dataProvider.currentRouteCard!.routeCardId;
    if (hiveDBProvider.isInternetConnected) {
      customers = await customerService.getCustomers(pattern);

      //! Save customers data in local DB
      final customersDataMap = Map<dynamic, CustomerModel>.fromIterable(
        customers,
        key: (r) => r.customerId,
        value: (c) => c,
      );
      await hiveDBProvider.customersBox!.clear();
      await hiveDBProvider.customersBox!.putAll(customersDataMap);

      //! Save route card items in local DB
      final List<int> priceLevelIdList = [];

      customers
          .map((c) => c.priceLevelId)
          .where((id) => id != null)
          .forEach((id) {
        if (!priceLevelIdList.contains(id)) {
          priceLevelIdList.add(id!);
        }
      });

      priceLevelIdList.forEach((id) async {
        final basicItemList = (await getItemsByRoutecard(
          routeCardId: routeCardId!,
          priceLevelId: id,
          type: '',
        ))
            .where((element) => (element.transferQty - element.sellQty) != 0)
            .toList();
        final newItemsList = await getNewItems(
          routeCardId: routeCardId,
          priceLevelId: id,
        );
        final newItems =
            newItemsList.where((i) => i.item?.itemTypeId != 3).toList();
        final otherItems =
            newItemsList.where((i) => i.item?.itemTypeId == 3).toList();
        try {
          await hiveDBProvider.routeCardBasicItemBox!.put(id, basicItemList);
          await hiveDBProvider.routeCardNewItemBox!.put(id, newItems);
          await hiveDBProvider.routeCardOtherItemBox!.put(id, otherItems);
        } catch (e) {
          print(e.toString());
        }
      });
    } else {
      customers = hiveDBProvider.customersBox?.values.toList() ?? [];
    }
    return customers;
  }
}
