import 'package:flutter/material.dart';
import 'package:gsr/models/response.dart';
import 'package:gsr/modules/return_cylinder/model/request/return_cylinder_request.dart';
import 'package:gsr/modules/return_cylinder/providers/return_cylinder_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../../../commons/common_methods.dart';

class ReturnCylinderService {
  static Future<String> returnCylinderInvoiceNumber(
      BuildContext context) async {
    final routeCard = context.read<DataProvider>().currentRouteCard!;
    final response = await respo(
        'return-cylinder-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  static Future<Respo> createReturnCylinderInvoice(
      ReturnCylinderInvoiceRequest request) async {
    try {
      final invoiceResponse = await respo(
        'return-cylinder-invoice/create',
        method: Method.post,
        data: request.toJson(),
      );
      return invoiceResponse;
    } catch (e) {
      toast(e.toString());
      rethrow;
    }
  }

  static Future<void> updateCreditInvoiceStatus({
    required int invoiceId,
    required int status,
    required double creditValue,
  }) async {
    await respo(
      'invoice/update',
      method: Method.put,
      data: {
        "invoiceId": invoiceId,
        "status": status,
        "creditValue": creditValue
      },
    );
  }
}
