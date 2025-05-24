import 'package:flutter/material.dart';
import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/models/employee/employee_model.dart';
import 'package:gsr/models/route_card.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/cylinder.dart';
import '../models/invoice/invoice_model.dart';
import '../models/response.dart';
import '../models/route_card/route_card_model.dart';

class InvoiceService {
  Future<String> invoiceNumber(RouteCard routeCard) async {
    final response =
        await respo('invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> returnCylinderInvoiceNumber(RouteCardModel routeCard) async {
    final response = await respo(
        'return-cylinder-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> loanInvoiceNumber(RouteCardModel routeCard) async {
    final response = await respo(
        'loan-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> leakInvoiceNumber(RouteCardModel routeCard) async {
    final response = await respo(
        'leak-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<void> updateInvoice(
      int invoiceId, int status, double creditValue) async {
    respo('invoice/update', method: Method.put, data: {
      "invoiceId": invoiceId,
      "status": status,
      "creditValue": creditValue
    });
  }

  Future<void> updateCheque(
      {required int chequeId, required double balance, int? isActive}) async {
    final data = {"id": chequeId, "balance": balance};
    if (isActive != null) {
      data["isActive"] = isActive;
    }
    respo('cheque/update', method: Method.put, data: data);
  }

  Future<Respo> createLoanInvoice(
      {required RouteCardModel routeCard,
      required CustomerModel customer,
      required List<AddedItem> itemList,
      int? loanType,
      required EmployeeModel employee}) async {
    try {
      final invoiceNo = await loanInvoiceNumber(routeCard);
      //! Create invoice
      final invoiceResponse = await respo(
        'loan-invoice/create',
        method: Method.post,
        data: {
          "invoice": {
            "invoiceNo":
                invoiceNo.replaceAll('RCN', loanType == 2 ? 'LO/R' : 'LO/I'),
            "routecardId": routeCard.routeCardId,
            "customerId": customer.customerId,
            "employeeId": employee.employeeId,
            "status": loanType,
          },
          "invoiceItems": itemList
              .map((invoiceItem) => {
                    "itemId": invoiceItem.item.id,
                    "itemQty": invoiceItem.quantity,
                    "routecardId": routeCard.routeCardId,
                    "customerId1": customer.customerId,
                  })
              .toList()
        },
      );
      return invoiceResponse;
    } catch (e) {
      toast(e.toString());
      rethrow;
    }
  }

  Future<Respo> createLeakInvoice(
      {required RouteCardModel routeCard,
      required CustomerModel customer,
      required List<AddedItem> itemList,
      required List<int> selectedCylinderItemIds,
      required EmployeeModel employee,
      required List<Cylinder> selectedCylinderList,
      int? leakType}) async {
    try {
      final invoiceNo = await leakInvoiceNumber(routeCard);
      //! Create invoice
      final invoiceResponse = await respo(
        'leak-invoice/create',
        method: Method.post,
        data: {
          "invoice": {
            "invoiceNo":
                invoiceNo.replaceAll('RCN', leakType == 2 ? 'LE/R' : 'LE/I'),
            "routecardId": routeCard.routeCardId,
            "customerId": customer.customerId,
            "employeeId": employee.employeeId,
            "status": leakType,
          },
          "invoiceItems": leakType == 2
              ? itemList
                  .map((invoiceItem) => {
                        "itemId": invoiceItem.item.id,
                        "itemQty": invoiceItem.quantity,
                        "routecardId": routeCard.routeCardId,
                        "customerId1": customer.customerId,
                        "cylinderNo": invoiceItem.item.cylinderNo,
                        "referenceNo": invoiceItem.item.referenceNo,
                        "status": leakType == 2 ? 1 : 6
                      })
                  .toList()
              : selectedCylinderList
                  .map((cylinder) => {
                        "id": cylinder.id,
                        "status": 6,
                        "routecardId": routeCard.routeCardId,
                        "freeCylinderId": cylinder.freeCylinderId
                      })
                  .toList()
        },
      );

      return invoiceResponse;
    } catch (e) {
      toast(e.toString());
      rethrow;
    }
  }

   Future<int> invoiceCount(int routeCardId) async {
    final response =
        await respo('invoice/count-by-routecard?id=$routeCardId');
    final int count = response.data;
    return count;
  }

   Future<List<InvoiceModel>> getCreditInvoices(BuildContext context,
      {int? cId, String? type, int? invoiceId}) async {
    String url =
        'invoice/get?customerId=${cId ?? context.read<DataProvider>().selectedCustomer!.customerId}';
    if (type != null) {
      url = '$url&type=$type';
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
}
