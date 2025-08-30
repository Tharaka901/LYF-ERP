import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/invoice/invoice_model.dart';
import '../models/response.dart';
import '../providers/data_provider.dart';

class InvoiceService {
  Future<int> invoiceCount(int routeCardId) async {
    final response =
        await respo('invoice/count-by-routecard?id=${routeCardId}');
    final int count = response.data;
    return count;
  }

  Future<Respo> createInvoice(dynamic request) async {
    try {
      //! Create invoice
      final invoiceResponse = await respo(
        'invoice/create',
        method: Method.post,
        data: request,
      );
      return invoiceResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvoiceModel>> getCreditInvoices(BuildContext context,
      {int? cId, String? type, int? invoiceId}) async {
    String url =
        'invoice/get?customerId=${cId ?? context.read<DataProvider>().selectedCustomer!.customerId}';
    if (type != null) {
      url = url + '&type=${type}';
    }

    final response = await respo(url);
    List<dynamic> list = response.data;
    return list
        .where((element) => element['status'] == 1 || element['status'] == 99)
        .map((e) {
          return InvoiceModel.fromJson(e);
        })
        .where((ii) => ii.creditValue != 0 && ii.invoiceId != (invoiceId ?? 0))
        .toList();
  }

  Future<List<InvoiceModel>> getIssuedInvoices(BuildContext context) async {
    final response = await respo(
        'invoice/get?routecardId=${context.read<DataProvider>().currentRouteCard!.routeCardId}');

    List<dynamic> list = response.data ?? [];
    List<InvoiceModel> selectedInvoiceList = [];
    final allInvoiceList = list.map((e) => InvoiceModel.fromJson(e)).toList();
    for (var element in allInvoiceList) {
      if (element.status != 3) {
        selectedInvoiceList.add(element);
      }
    }
    selectedInvoiceList.sort((a, b) =>
        DateTime.parse(a.createdAt ?? DateTime.now().toString()).compareTo(DateTime.parse(b.createdAt!)));
    return selectedInvoiceList;
  }
}
