import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/models/employee/employee_model.dart';
import 'package:gsr/models/route_card.dart';

import '../commons/common_methods.dart';
import '../models/cylinder.dart';
import '../models/response.dart';

class InvoiceService {
  Future<String> invoiceNumber(RouteCard routeCard) async {
    final response =
        await respo('invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> returnCylinderInvoiceNumber(RouteCard routeCard) async {
    final response = await respo(
        'return-cylinder-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> loanInvoiceNumber(RouteCard routeCard) async {
    final response = await respo(
        'loan-invoice/count-by-routecard?id=${routeCard.routeCardId}');
    final int count = response.data;
    return '${routeCard.routeCardNo}/${count + 1}';
  }

  Future<String> leakInvoiceNumber(RouteCard routeCard) async {
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
      {required RouteCard routeCard,
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
      {required RouteCard routeCard,
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
}
