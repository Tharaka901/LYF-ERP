import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/balance_payment.dart';
import 'package:gsr/models/credit_payment.dart';
import 'package:gsr/models/customer.dart';
import 'package:gsr/models/customer_deposite.dart';
import 'package:gsr/models/cylinder.dart';
import 'package:gsr/models/employee.dart';
import 'package:gsr/models/issued_invoice.dart';
import 'package:gsr/models/item.dart';
import 'package:gsr/models/item_summary.dart' as it;
import 'package:gsr/models/item_summary_customer_wise.dart' as itcw;
import 'package:gsr/models/loanItem.dart';
import 'package:gsr/models/loan_stock.dart' as ls;
import 'package:gsr/models/payment.dart';
import 'package:gsr/models/payments.dart';
import 'package:gsr/models/rcItemSummary.dart';
import 'package:gsr/models/response.dart';
import 'package:gsr/models/route_card.dart';
import 'package:gsr/models/routecard_item.dart';
import 'package:gsr/models/voucher.dart';
import 'package:gsr/modules/invoice/invoice_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/select_customer_screen.dart';
import 'package:gsr/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/credit_payment/credit_payment_model.dart';

login(
  BuildContext context, {
  required String contactNumber,
  required String password,
}) async {
  await respo(
    'employees/login',
    data: {
      'contactNumber': contactNumber,
      'password': password,
    },
    method: Method.post,
  ).then((response) async {
    if (response.success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', contactNumber).then((success) async {
        success
            ? await prefs.setString('password', password).then((value) {
                context
                    .read<DataProvider>()
                    .setCurrentEmployee(Employee.fromJson(response.data));
                toast(
                  'Logged in successfully',
                  toastState: TS.success,
                );
                pop(context);
                Navigator.pushReplacementNamed(context, HomeScreen.routeId);
              })
            : await prefs.remove('password');
      });
    } else {
      pop(context);
      toast(
        response.error ?? 'Error occured!',
        toastState: TS.error,
      );
    }
  }).onError((error, stackTrace) {
    toast(
      error.toString(),
      toastState: TS.error,
    );
  });
}

Future<Respo> loginStart(
  BuildContext context, {
  required String contactNumber,
  required String password,
}) async {
  Respo t;
  try {
    t = await respo(
      'employees/login',
      data: {
        'contactNumber': contactNumber,
        'password': password,
      },
      method: Method.post,
    );
    print(t.data);
  } catch (e) {
    print(e);
    rethrow;
  }
  return t;
}

Future<List<RoutecardItem>> getLoanItems(int routeCardId, {int? status}) async {
  try {
    final response = await respo(
        'items/get-loan?routecardId=$routeCardId&status=${status ?? 5}');
    List<dynamic> list = response.data;
    return list.map((element) {
      LoanItem loanItem = LoanItem.fromJson(element);
      return RoutecardItem(
          routecardItemsId: loanItem.cardItem?.routecardItemsId ?? 0,
          itemId: loanItem.cardItem?.itemId ?? 0,
          transferQty: loanItem.cardItem?.transferQty?.toDouble() ?? 0,
          sellQty: loanItem.cardItem?.sellQty?.toDouble() ?? 0,
          routecardId: loanItem.cardItem?.routecardId ?? 0,
          status: loanItem.cardItem?.status ?? 0,
          item: Item(
              id: loanItem.id ?? 0,
              itemRegNo: loanItem.itemRegNo ?? '',
              itemName: loanItem.itemName ?? '',
              costPrice: loanItem.costPrice?.toDouble() ?? 0,
              salePrice: loanItem.salePrice?.toDouble() ?? 0,
              openingQty: loanItem.openingQty?.toDouble() ?? 0,
              vendorId: loanItem.vendorId?.toInt() ?? 0,
              priceLevelId: loanItem.priceLevelId?.toInt() ?? 0,
              itemTypeId: loanItem.itemTypeId?.toInt() ?? 0,
              stockId: loanItem.stockId?.toInt() ?? 0,
              costAccId: loanItem.costAccId?.toInt() ?? 0,
              incomeAccId: loanItem.incomeAccId?.toInt() ?? 0,
              isNew: loanItem.isNew?.toInt() ?? 0,
              status: loanItem.status?.toInt() ?? 0));
    }).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<RoutecardItem>> getLeakIssueItems(int routeCardId, int customerId1,
    {int? status}) async {
  try {
    final response = await respo(
        'items/leak-issue?routecardId=$routeCardId&customerId1=${customerId1}');
    List<dynamic> list = response.data;

    return list.map((element) {
      LoanItem loanItem = LoanItem.fromJson(element);
      return RoutecardItem(
          routecardItemsId: loanItem.cardItem?.routecardItemsId ?? 0,
          itemId: loanItem.cardItem?.itemId ?? 0,
          transferQty: loanItem.cardItem?.transferQty?.toDouble() ?? 0,
          sellQty: loanItem.cardItem?.sellQty?.toDouble() ?? 0,
          routecardId: loanItem.cardItem?.routecardId ?? 0,
          status: loanItem.cardItem?.status ?? 0,
          item: Item(
              id: loanItem.id ?? 0,
              itemRegNo: loanItem.itemRegNo ?? '',
              itemName: loanItem.itemName ?? '',
              costPrice: loanItem.costPrice?.toDouble() ?? 0,
              salePrice: loanItem.salePrice?.toDouble() ?? 0,
              openingQty: loanItem.openingQty?.toDouble() ?? 0,
              vendorId: loanItem.vendorId?.toInt() ?? 0,
              priceLevelId: loanItem.priceLevelId?.toInt() ?? 0,
              itemTypeId: loanItem.itemTypeId?.toInt() ?? 0,
              stockId: loanItem.stockId?.toInt() ?? 0,
              costAccId: loanItem.costAccId?.toInt() ?? 0,
              incomeAccId: loanItem.incomeAccId?.toInt() ?? 0,
              isNew: loanItem.isNew?.toInt() ?? 0,
              status: loanItem.status?.toInt() ?? 0));
    }).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<ls.LoanStock>> getLoanStock(int routeCardId) async {
  try {
    final response = await respo('route-card/get-summary-with-loan-items',
        method: Method.post, data: {"routecardId": routeCardId});
    List<dynamic> list = response.data;
    return list.map((e) => ls.LoanStock.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<ls.LoanStock>> getLeakStock(int routeCardId) async {
  try {
    final response = await respo('route-card/get-summary-with-leak-items',
        method: Method.post, data: {"routecardId": routeCardId});
    List<dynamic> list = response.data;
    return list.map((e) => ls.LoanStock.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<Cylinder>> getCylindersByItemId(int customerId, int itemId) async {
  try {
    final response = await respo(
        'items/get-cylinders-by-item?customerId=$customerId&itemId=$itemId',
        method: Method.get);
    List<dynamic> list = response.data;
    return list.map((e) => Cylinder.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<it.ItemSummary>> getItemSummary(int routeCardId) async {
  try {
    final response = await respo('route-card/get-summary-with-items',
        method: Method.post, data: {"routecardId": routeCardId});
    List<dynamic> list = response.data;
    print(response.data);
    return list.map((e) => it.ItemSummary.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<itcw.ItemSummaryCustomerWise>> getItemSummaryCustomerWise(
    int routeCardId) async {
  try {
    final response = await respo('route-card/get-summary-customer-wise',
        method: Method.post, data: {"routecardId": routeCardId});
    List<dynamic> list = response.data;
    return list.map((e) => itcw.ItemSummaryCustomerWise.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<itcw.ItemSummaryCustomerWise>> getItemSummaryCustomerWiseLeak(
    int routeCardId) async {
  try {
    final response = await respo('route-card/get-summary-leak-customer-wise',
        method: Method.post, data: {"routecardId": routeCardId});
    List<dynamic> list = response.data;
    return list.map((e) => itcw.ItemSummaryCustomerWise.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<itcw.ItemSummaryCustomerWise>>
    getReturnCylinderSummaryCustomerWiseLeak(int routeCardId) async {
  try {
    final response = await respo(
        'route-card/get-summary-return-cylinder-customer-wise',
        method: Method.post,
        data: {"routecardId": routeCardId});
    List<dynamic> list = response.data;
    return list.map((e) => itcw.ItemSummaryCustomerWise.fromJson(e)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<RoutecardItem>> getItemsByRoutecard(
    {required int routeCardId,
    required int priceLevelId,
    bool onlyDeposit = false,
    bool onlyRefill = true,
    String? type}) async {
  if (type == 'rc-summary') {
    final response =
        await respo('items/get-all-by-route-card?routecardId=$routeCardId');
    List<dynamic> list = response.data;

    return list.map((element) => RoutecardItem.fromJson(element)).toList();
  } else if (type == 'return') {
    List<RoutecardItem> returnItems = [];
    final response = await respo('items/get-return?priceLevelId=$priceLevelId');
    List<dynamic> list = response.data;
    for (var element in list) {
      final item = Item.fromJson(element);
      returnItems.add(RoutecardItem(
        routecardItemsId: 0,
        itemId: item.id,
        transferQty: 1,
        sellQty: 0,
        routecardId: 0,
        status: 0,
        item: item,
      ));
    }
    return returnItems;
  }
  final response = await respo(
      'items/get-all-by-route-card?routecardId=$routeCardId&priceLevelId=$priceLevelId');
  List<dynamic> list = response.data ?? [];

  List<RoutecardItem> allItems = [];
  final items = onlyRefill
      ? list
          .map((element) => RoutecardItem.fromJson(element))
          .where((rci) => rci.item!.itemTypeId != 3)
          .toList()
      : onlyDeposit
          ? list
              .map((element) => RoutecardItem.fromJson(element))
              .where((rci) => rci.item!.itemTypeId == 3)
              .toList()
          : list.map((element) => RoutecardItem.fromJson(element)).toList();
  for (var element in items) {
    if (!(allItems.map((e) => e.item?.itemName).toList())
        .contains(element.item?.itemName)) {
      allItems.add(element);
    }
  }
  return allItems.where((element) => element.item?.itemTypeId != 5).toList();
}

Future<List<RcItemsSummary>> getItemsSummaryByRoutecard({
  required int routeCardId,
}) async {
  try {
    final rcItemSumary = await respo('route-card/get-item-summary',
        data: {'routecardId': routeCardId.toString()}, method: Method.post);
    return (rcItemSumary.data as List)
        .map((i) => RcItemsSummary.fromJson(i))
        .toList();
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}

Future<List<RoutecardItem>> getNewItems({
  required int routeCardId,
  required int priceLevelId,
}) async {
  final refillItemsList = await getItemsByRoutecard(
    routeCardId: routeCardId,
    priceLevelId: priceLevelId,
    onlyRefill: true,
    onlyDeposit: false,
  );
  final newResponse = await respo(
      'items/get-new?priceLevelId=$priceLevelId&routecardId=$routeCardId');
  List<dynamic> newItemList = newResponse.data ?? [];
  List<RoutecardItem> rcNewItems = [];
  final response = await respo(
      'items/get-all-by-route-card?routecardId=$routeCardId&priceLevelId=$priceLevelId');
  List<dynamic> list = response.data ?? [];
  final list2 = list.map((element) => RoutecardItem.fromJson(element)).toList();
  for (var element in list2) {
    if (element.item?.itemTypeId == 3) {
      rcNewItems.add(element);
    }
  }
  for (var element in refillItemsList) {
    if (element.status == 2) {
      refillItemsList.add(element);
    }
  }
  for (var element in newItemList) {
    final item = Item.fromJson(element);
    for (var element2 in refillItemsList) {
      if (item.itemName.replaceAll('Deposit', 'Refill') ==
          element2.item?.itemName) {
        rcNewItems.add(RoutecardItem(
          routecardItemsId: 0,
          itemId: item.id,
          transferQty: element2.transferQty,
          sellQty: 0,
          routecardId: 0,
          status: 0,
          item: item,
        ));
      }
    }
  }
  return rcNewItems;
}

Future<List<RouteCard>> getRouteCards(int uid,
    {RC? rcStatus = RC.pending}) async {
  try {
    Respo response;
    if (rcStatus == RC.pending ||
        rcStatus == RC.accepted ||
        rcStatus == RC.rejected ||
        rcStatus == RC.pendingOrAccepted) {
      response = await respo(
          'route-card/get-by-uid/$uid?status=${rcStatus == RC.pending ? 0 : rcStatus == RC.accepted ? 1 : rcStatus == RC.rejected ? 4 : rcStatus == RC.pendingOrAccepted ? 10 : 2}');
    } else {
      response = await respo('route-card/get-by-uid/$uid?status=2,3,5');
    }
    List<dynamic> list = response.data;
    return list.map((element) => RouteCard.fromJson(element)).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<RouteCard>> getPendingAndAcceptedRouteCards(int uid) async {
  final response = await respo(
    'route-card/get-by-uid/$uid?status=10',
  );
  List<dynamic> list = response.data;
  return list
      .map((element) => RouteCard.fromJson(element))
      .where((rc) => (rc.status == 0 || rc.status == 1))
      .toList();
}

Future<List<Payment>> getPayments(
  BuildContext context, {
  required int routecardId,
  required int paymentMethod,
}) async {
  final response = await respo(
      'payment/get?routecardId=$routecardId&paymentMethod=$paymentMethod');
  List<dynamic> list = response.data;
  return list.map((element) => Payment.fromJson(element)).toList();
}

Future<List<CreditPaymentModel>> getCreditPayments({
  required int routecardId,
}) async {
  final response = await respo('credit-payment/get?routecardId=$routecardId');
  List<dynamic> list = response.data ?? [];
  List<CreditPaymentModel> selectedReceiptList = [];
  final receiptList =
      list.map((element) => CreditPaymentModel.fromJson(element)).toList();
  for (var element in receiptList) {
    if (!selectedReceiptList
        .map((e) => e.receiptNo)
        .toList()
        .contains(element.receiptNo)) {
      if (element.status == 1 || element.status == 3) {
        selectedReceiptList.add(element);
      }
    }
  }

  return selectedReceiptList;
}

Future<List<CreditPayment>> getCreditPaymentsByReceipt({
  required String receiptNo,
}) async {
  final response = await respo('credit-payment/get?receiptNo=$receiptNo');
  List<dynamic> list = response.data;
  return list.map((element) => CreditPayment.fromJson(element)).toList();
}

enum RC {
  accepted,
  completed,
  pending,
  pendingOrAccepted,
  rejected,
}

Future<Customer> getQRCustomer() async {
  final response = await respo('customers/get_customer_by_qr');
  return Customer.fromJson(response.data);
}

Future<List<IssuedInvoice>> creditInvoices(BuildContext context,
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
        return IssuedInvoice.fromJson(e);
      })
      .where((ii) => ii.creditValue != 0 && ii.invoiceId != (invoiceId ?? 0))
      .toList();
}

Future<List<CustomerDeposite>> getCustomerDeposites(BuildContext context,
    {int? cId, int? routecardId}) async {
  try {
    final response = await respo(
        'over-payment/get?customerId=${cId ?? context.read<DataProvider>().selectedCustomer!.customerId}&routecardId=${routecardId}');
    List<dynamic> list = response.data;
    return list
        .where((element) => (element['status'] == 1 || element['status'] == 2))
        .map((e) {
      return CustomerDeposite.fromJson(e);
    }).toList();
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<List<IssuedInvoice>> getIssuedInvoices(BuildContext context) async {
  final response = await respo(
      'invoice/get?routecardId=${context.read<DataProvider>().currentRouteCard!.routeCardId}');

  List<dynamic> list = response.data ?? [];
  List<IssuedInvoice> selectedInvoiceList = [];
  final allInvoiceList = list.map((e) => IssuedInvoice.fromJson(e)).toList();
  for (var element in allInvoiceList) {
    if (element.status != 3) {
      selectedInvoiceList.add(element);
    }
  }
  selectedInvoiceList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return selectedInvoiceList;
}

Future<List<BalancePayment>> getBalancePayments(BuildContext context,
    {required int invoiceId}) async {
  final response = await respo('balance-payment/get?invoiceId=$invoiceId');
  List<dynamic> list = response.data;
  return list.map((e) => BalancePayment.fromJson(e)).toList();
}

Future<String> invoiceNumber(BuildContext context) async {
  final routeCard = context.read<DataProvider>().currentRouteCard!;
  final response =
      await respo('invoice/count-by-routecard?id=${routeCard.routeCardId}');
  final int count = response.data;
  return '${routeCard.routeCardNo}/${count + 1}';
}

Future<String> loanInvoiceNumber(BuildContext context) async {
  final routeCard = context.read<DataProvider>().currentRouteCard!;
  final response = await respo(
      'loan-invoice/count-by-routecard?id=${routeCard.routeCardId}');
  final int count = response.data;
  return '${routeCard.routeCardNo}/${count + 1}';
}

Future<String> returnCylinderInvoiceNumber(BuildContext context) async {
  final routeCard = context.read<DataProvider>().currentRouteCard!;
  final response = await respo(
      'return-cylinder-invoice/count-by-routecard?id=${routeCard.routeCardId}');
  final int count = response.data;
  return '${routeCard.routeCardNo}/${count + 1}';
}

Future<String> leakInvoiceNumber(BuildContext context) async {
  final routeCard = context.read<DataProvider>().currentRouteCard!;
  final response = await respo(
      'leak-invoice/count-by-routecard?id=${routeCard.routeCardId}');
  final int count = response.data;
  return '${routeCard.routeCardNo}/${count + 1}';
}

Future<String> getReceiptNumber(BuildContext context) async {
  final routeCard = context.read<DataProvider>().currentRouteCard!;
  final response = await respo('payment/count/?id=${routeCard.routeCardId}');
  final int count = response.data;
  return 'R/${routeCard.routeCardNo}/${count + 1}';
}

Future<List<Voucher>> getVouchers(BuildContext context) async {
  final response = await respo('voucher/all');
  List<dynamic> list = response.data;
  List<Voucher> vouchers = list.map((e) => Voucher.fromJson(e)).toList();
  vouchers.insert(
    0,
    Voucher(
      id: 0,
      code: 'None',
      value: 0.0,
    ),
  );
  return vouchers;
}

Future<void> updateRouteCard({
  required int routeCardId,
  required int status,
}) async {
  await respo('route-card/update', method: Method.post, data: {
    'routeCardId': routeCardId,
    'status': status,
  });
}

Future<List<Customer>> getCustomers(String pattern) async {
  try {
    final response = await respo('customers/get-all');
    List<dynamic> list = response.data;
    return list
        .map((element) => Customer.fromJson(element))
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

Future<Respo> createInvoice(BuildContext context, {String? invoiceNu}) async {
  try {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;
    final invoiceNo = invoiceProvider.invoiceNu;
    //! Create invoice
    final invoiceResponse = await respo(
      'invoice/create',
      method: Method.post,
      data: {
        "invoice": {
          "invoiceNo": invoiceNu ?? invoiceNo,
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "amount": double.parse((dataProvider.grandTotal).toStringAsFixed(2)),
          "subTotal": (dataProvider.getTotalAmount()).toStringAsFixed(2),
          "vat": double.parse((((dataProvider.getTotalAmount() / 100) * 18))
              .toStringAsFixed(2)),
          "nonVatItemTotal": dataProvider.nonVatItemTotal,
          "customerId": selectedCustomer.customerId,
          "creditValue":
              double.parse((dataProvider.grandTotal).toStringAsFixed(2)),
          "employeeId": dataProvider.currentEmployee!.employeeId,
          "status": 1,
        },
        "invoiceItems": dataProvider.itemList
            .map((invoiceItem) => {
                  "itemId": invoiceItem.item.id,
                  "itemPrice": invoiceItem.item.salePrice,
                  "itemQty": invoiceItem.quantity,
                  "status": invoiceItem.item.status,
                  "routecardId": dataProvider.currentRouteCard!.routeCardId,
                })
            .toList()
      },
    );
    return invoiceResponse;
  } catch (e) {
    rethrow;
  }
}

Future<Respo> createLoanInvoice(BuildContext context) async {
  try {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;
    final invoiceNo = await loanInvoiceNumber(context);
    //! Create invoice
    final invoiceResponse = await respo(
      'loan-invoice/create',
      method: Method.post,
      data: {
        "invoice": {
          "invoiceNo": invoiceNo.replaceAll(
              'RCN', dataProvider.itemList[0].loanType == 2 ? 'LO/R' : 'LO/I'),
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "customerId": selectedCustomer.customerId,
          "employeeId": dataProvider.currentEmployee!.employeeId,
          "status": dataProvider.itemList[0].loanType,
        },
        "invoiceItems": dataProvider.itemList
            .map((invoiceItem) => {
                  "itemId": invoiceItem.item.id,
                  "itemQty": invoiceItem.quantity,
                  "routecardId": dataProvider.currentRouteCard!.routeCardId,
                  "customerId1": selectedCustomer.customerId,
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

Future<Respo> createReturnCylinderInvoice(BuildContext context) async {
  try {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;
    final invoiceNo = await returnCylinderInvoiceNumber(context);
    //! Create invoice
    final invoiceResponse = await respo(
      'return-cylinder-invoice/create',
      method: Method.post,
      data: {
        "invoice": {
          "invoiceNo": 'GRN/' + invoiceNo,
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "customerId": selectedCustomer.customerId,
          "employeeId": dataProvider.currentEmployee!.employeeId,
          "status": dataProvider.itemList
                          .map((e) => e.item.salePrice * e.quantity)
                          .reduce((value, element) => value + element) -
                      dataProvider.getTotalInvoicePaymentAmount() ==
                  0
              ? 2
              : 1,
          "total": dataProvider.itemList
              .map((e) => e.item.salePrice * e.quantity)
              .reduce((value, element) => value + element),
          "balance": (dataProvider.itemList
                      .map((e) => e.item.salePrice * e.quantity)
                      .reduce((value, element) => value + element) -
                  dataProvider.getTotalInvoicePaymentAmount())
              .toStringAsFixed(2)
        },
        "invoiceItems": dataProvider.itemList
            .map((invoiceItem) => {
                  "itemId": invoiceItem.item.id,
                  "itemQty": invoiceItem.quantity,
                  "routecardId": dataProvider.currentRouteCard!.routeCardId,
                  "customerId1": selectedCustomer.customerId,
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

Future<Respo> createLeakInvoice(BuildContext context) async {
  try {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer!;
    final invoiceNo = await leakInvoiceNumber(context);
    //! Create invoice
    final invoiceResponse = await respo(
      'leak-invoice/create',
      method: Method.post,
      data: {
        "invoice": {
          "invoiceNo": invoiceNo.replaceAll(
              'RCN', dataProvider.itemList[0].leakType == 2 ? 'LE/R' : 'LE/I'),
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "customerId": selectedCustomer.customerId,
          "employeeId": dataProvider.currentEmployee!.employeeId,
          "status": dataProvider.itemList[0].leakType,
        },
        "invoiceItems": dataProvider.itemList[0].leakType == 2
            ? dataProvider.itemList
                .map((invoiceItem) => {
                      "itemId": invoiceItem.item.id,
                      "itemQty": invoiceItem.quantity,
                      "routecardId": dataProvider.currentRouteCard!.routeCardId,
                      "customerId1": selectedCustomer.customerId,
                      "cylinderNo": invoiceItem.item.cylinderNo,
                      "referenceNo": invoiceItem.item.referenceNo,
                      "status": dataProvider.itemList[0].leakType == 2 ? 1 : 6
                    })
                .toList()
            : dataProvider.selectedCylinderItemIds
                .map((id) => {
                      "id": id,
                      "status": 6,
                      "routecardId": dataProvider.currentRouteCard!.routeCardId,
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

Future<void> sendPaymentWithPrevious(BuildContext context, double total,
    double cash, double balance, Respo invoiceResponse,
    {String? receiptNo, bool? isOnlySave}) async {
  final dataProvider = Provider.of<DataProvider>(context, listen: false);
  final selectedCustomer = dataProvider.selectedCustomer!;

  try {
//! Create receipt number
    String? rn;
    if (receiptNo != null) {
      rn = receiptNo;
    } else {
      rn = await getReceiptNumber(context);
    }
    final invoiceId = invoiceResponse.data['invoice']['invoiceId'] as int;

    //! Create payment
    await respo(
      'payment/create',
      data: Payments(
        payments: [
          if (cash > 0)
            Payment(
              customerTypeId: selectedCustomer.customerTypeId,
              invoiceId: invoiceId,
              amount: cash,
              receiptNo: rn,
              paymentMethod: 1,
              chequeNo: null,
              routecardId: dataProvider.currentRouteCard!.routeCardId,
              routeId: dataProvider.currentRouteCard!.routeId,
              customerId: selectedCustomer.customerId,
              priceLevelId: selectedCustomer.priceLevelId,
              employeeId: dataProvider.currentEmployee!.employeeId,
              status: 1,
            ).toJson(),
          ...dataProvider.chequeList.map(
            (cheque) => Payment(
              customerTypeId: selectedCustomer.customerTypeId,
              invoiceId: invoiceId,
              amount: cheque.chequeAmount,
              chequeNo: cheque.chequeNumber,
              receiptNo: rn!,
              paymentMethod: 2,
              routecardId: dataProvider.currentRouteCard!.routeCardId,
              routeId: dataProvider.currentRouteCard!.routeId,
              customerId: selectedCustomer.customerId,
              priceLevelId: selectedCustomer.priceLevelId,
              employeeId: dataProvider.currentEmployee!.employeeId,
              status: 1,
            ).toJson(),
          ),
        ],
      ).toJson(),
      method: Method.post,
    );
    if (balance > 0) {
      await respo(
        'customers/update',
        method: Method.put,
        data: {
          "customerId": selectedCustomer.customerId,
          "depositBalance": selectedCustomer.depositBalance + balance,
        },
      );
      await respo(
        'over-payment/create',
        method: Method.post,
        data: {
          "value": balance,
          "status": 1,
          "paymentInvoiceId": invoiceId,
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "receiptNo": rn,
          "customerId": selectedCustomer.customerId
        },
      );
    }
    if (isOnlySave ?? false) {
      dataProvider.chequeList.clear();
      dataProvider.issuedInvoicePaidList.clear();
    }
    //! Create voucher payment
    if (dataProvider.selectedVoucher != null) {
      await respo(
        'payment/create',
        method: Method.post,
        data: Payments(
          payments: [
            Payment(
              customerTypeId: selectedCustomer.customerTypeId,
              invoiceId: invoiceId,
              amount: dataProvider.selectedVoucher != null
                  ? dataProvider.selectedVoucher!.value
                  : 0.0,
              chequeNo: dataProvider.selectedVoucher != null
                  ? dataProvider.selectedVoucher!.code
                  : null,
              receiptNo: rn,
              paymentMethod: 3,
              routecardId: dataProvider.currentRouteCard!.routeCardId,
              routeId: dataProvider.currentRouteCard!.routeId,
              customerId: selectedCustomer.customerId,
              priceLevelId: selectedCustomer.priceLevelId,
              employeeId: dataProvider.currentEmployee!.employeeId,
              status: 1,
            ).toJson(),
          ],
        ).toJson(),
      );
    }

//! Update over payment
    if (dataProvider.issuedDepositePaidList.isNotEmpty) {
      await respo(
        'over-payment/update',
        method: Method.put,
        data: {
          "overPaymentsPayList": [
            ...dataProvider.issuedDepositePaidList
                .map((e) => {
                      "value": (e.depositeValue! - e.paymentAmount).toInt(),
                      "customerId": dataProvider.selectedCustomer?.customerId,
                      "paymentInvoiceId": e.issuedDeposite.paymentInvoiceId
                    })
                .toList()
          ]
        },
      );
    }

    //! Update return cylinder invoice balance
    for (var rci in dataProvider.issuedDepositePaidList) {
      if (rci.issuedDeposite.status == 2) {
        await respo('return-cylinder-invoice/update',
            method: Method.put,
            data: {
              "invoiceNo": rci.issuedDeposite.receiptNo,
              "balance": rci.issuedDeposite.value! - rci.paymentAmount,
              "status":
                  rci.issuedDeposite.value! - rci.paymentAmount == 0 ? 2 : 1
            });
      }
    }

    if (isOnlySave ?? false) {
      dataProvider.issuedDepositePaidList.clear();
    }

    // //! Create invoice
    await respo(
      'invoice/update',
      method: Method.put,
      data: {
        "invoiceId": invoiceResponse.data['invoice']['invoiceId'] as int,
        "status": 2,
        "creditValue": 0
      },
    );
    if (isOnlySave ?? false) {
      dataProvider.itemList.clear();
    }

    for (var invoice in dataProvider.issuedInvoicePaidList) {
      final data = {
        "value": invoice.paymentAmount,
        "paymentInvoiceId": invoiceId,
        "routecardId": dataProvider.currentRouteCard!.routeCardId,
        "creditInvoiceId": invoice.chequeId != null
            ? invoice.chequeId
            : invoice.issuedInvoice.invoiceId,
        "receiptNo": rn,
        "status": invoice.chequeId != null ? 3 : 2,
        "type": invoice.chequeId != null ? "return-cheque" : 'default'
      };
      await respo('credit-payment/create', method: Method.post, data: data);
      if (invoice.creditAmount! <= invoice.paymentAmount &&
          invoice.chequeId == null) {
        await respo('invoice/update',
            method: Method.put,
            data: {"invoiceId": invoice.issuedInvoice.invoiceId, "status": 2});
      }

      if (invoice.chequeId != null) {
        if (invoice.creditAmount! <= invoice.paymentAmount) {
          await respo('cheque/update',
              method: Method.put,
              data: {"id": invoice.chequeId, "isActive": 2, "balance": 0});
        } else {
          await respo('cheque/update', method: Method.put, data: {
            "id": invoice.chequeId,
            "balance": invoice.creditAmount! - invoice.paymentAmount
          });
        }
      }
    }

    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    invoiceProvider.invoiceNu = null;
    invoiceProvider.invoiceRes = null;

    Navigator.popUntil(
        context, ModalRoute.withName(SelectCustomerScreen.routeId));
    toast(
      'Sent successfully',
      toastState: TS.success,
    );
  } catch (e) {
    rethrow;
  }
}

Future<void> sendCreditPayment(BuildContext context, double total, double cash,
    bool isDirectPrevoius, double balance,
    {String? receiptNo}) async {
  final dataProvider = Provider.of<DataProvider>(context, listen: false);
  final selectedCustomer = dataProvider.selectedCustomer!;
  final invoiceNo = await invoiceNumber(context);

  await respo('invoice/create-single', method: Method.post, data: {
    "invoice": {
      "invoiceNo": invoiceNo,
      "routecardId": dataProvider.currentRouteCard!.routeCardId,
      "amount": dataProvider.getTotalAmount(),
      "customerId": selectedCustomer.customerId,
      "creditValue": 0,
      "vat": 0,
      "subTotal": 0,
      "employeeId": dataProvider.currentEmployee!.employeeId,
      "nonVatItemTotal": 0,
      "status": !isDirectPrevoius ? 3 : 4,
    },
  }).then((invoiceResponse) async {
    final invoiceId = invoiceResponse.data['invoiceId'] as int;
    await getReceiptNumber(context).then((rn) async {
      for (var invoice in dataProvider.issuedInvoicePaidList) {
        final data = {
          "value": invoice.paymentAmount,
          "paymentInvoiceId": invoiceId,
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "creditInvoiceId": invoice.chequeId != null
              ? invoice.chequeId
              : invoice.issuedInvoice.invoiceId,
          "receiptNo": receiptNo ?? rn,
          "status": invoice.chequeId != null ? 3 : 1,
          "type": invoice.chequeId != null ? "return-cheque" : 'default'
        };
        await respo('credit-payment/create', method: Method.post, data: data);
        if (invoice.creditAmount! <= invoice.paymentAmount &&
            invoice.chequeId == null) {
          await respo('invoice/update', method: Method.put, data: {
            "invoiceId": invoice.issuedInvoice.invoiceId,
            "status": 2
          });
        }
        if (invoice.chequeId != null) {
          if (invoice.creditAmount! <= invoice.paymentAmount) {
            await respo('cheque/update',
                method: Method.put,
                data: {"id": invoice.chequeId, "isActive": 2, "balance": 0});
          } else {
            await respo('cheque/update', method: Method.put, data: {
              "id": invoice.chequeId,
              "balance": invoice.creditAmount! - invoice.paymentAmount
            });
          }
        }
      }

      await respo('payment/create',
          method: Method.post,
          data: Payments(
            payments: [
              if (cash > 0)
                Payment(
                  customerTypeId: selectedCustomer.customerTypeId,
                  invoiceId: invoiceId,
                  amount: cash,
                  receiptNo: receiptNo ?? rn,
                  paymentMethod: 1,
                  chequeNo: null,
                  routecardId: dataProvider.currentRouteCard!.routeCardId,
                  routeId: dataProvider.currentRouteCard!.routeId,
                  customerId: selectedCustomer.customerId,
                  priceLevelId: selectedCustomer.priceLevelId,
                  employeeId: dataProvider.currentEmployee!.employeeId,
                  status: 1,
                ).toJson(),
              ...dataProvider.chequeList.map(
                (cheque) => Payment(
                  customerTypeId: selectedCustomer.customerTypeId,
                  invoiceId: invoiceId,
                  amount: cheque.chequeAmount,
                  chequeNo: cheque.chequeNumber,
                  receiptNo: receiptNo ?? rn,
                  paymentMethod: 2,
                  routecardId: dataProvider.currentRouteCard!.routeCardId,
                  routeId: dataProvider.currentRouteCard!.routeId,
                  customerId: selectedCustomer.customerId,
                  priceLevelId: selectedCustomer.priceLevelId,
                  employeeId: dataProvider.currentEmployee!.employeeId,
                  status: 1,
                ).toJson(),
              ),
            ],
          ).toJson());
      if (total >
          dataProvider.issuedInvoicePaidList
              .map((e) => e.paymentAmount)
              .toList()
              .reduce((value, element) => value + element)) {
        await respo(
          'customers/update',
          method: Method.put,
          data: {
            "customerId": selectedCustomer.customerId,
            "depositBalance": selectedCustomer.depositBalance +
                (total -
                    dataProvider.issuedInvoicePaidList
                        .map((e) => e.paymentAmount)
                        .toList()
                        .reduce((value, element) => value + element)),
          },
        );
        await respo(
          'over-payment/create',
          method: Method.post,
          data: {
            "value": (total -
                dataProvider.issuedInvoicePaidList
                    .map((e) => e.paymentAmount)
                    .toList()
                    .reduce((value, element) => value + element)),
            "status": 1,
            "paymentInvoiceId": invoiceId,
            "routecardId": dataProvider.currentRouteCard!.routeCardId,
            "receiptNo": receiptNo ?? rn,
            "customerId": selectedCustomer.customerId
          },
        );
      }
    });
    dataProvider.chequeList.clear();
    //! Update over payment
    if (dataProvider.issuedDepositePaidList.isNotEmpty) {
      await respo(
        'over-payment/update',
        method: Method.put,
        data: {
          "overPaymentsPayList": [
            ...dataProvider.issuedDepositePaidList
                .map((e) => {
                      "value": (e.depositeValue! - e.paymentAmount).toInt(),
                      "customerId": dataProvider.selectedCustomer?.customerId,
                      "paymentInvoiceId": e.issuedDeposite.paymentInvoiceId
                    })
                .toList()
          ]
        },
      );
    }
  });
  final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
  invoiceProvider.invoiceNu = null;
  invoiceProvider.invoiceRes = null;
  // .then((value) {
  //   if (!isDirectPrevoius) {
  //     Navigator.popUntil(context, ModalRoute.withName(PreviousScreen.routeId));
  //   } else {
  //     Navigator.popUntil(
  //         context, ModalRoute.withName(SelectCustomerScreen.routeId));
  //   }
  //   toast(
  //     'Sent successfully',
  //     toastState: TS.success,
  //   );
  // });
}

Future<void> sendPayment(BuildContext context,
    {required double totalPayment,
    required double cash,
    required double balance,
    bool? isDirectPrevoius,
    required Respo invoiceResponse,
    String? receiptNo,
    bool? isOnlySave}) async {
  final dataProvider = Provider.of<DataProvider>(context, listen: false);
  final selectedCustomer = dataProvider.selectedCustomer!;
  try {
//! Update over payment
    if (dataProvider.issuedDepositePaidList.isNotEmpty) {
      await respo(
        'over-payment/update',
        method: Method.put,
        data: {
          "overPaymentsPayList": [
            ...dataProvider.issuedDepositePaidList
                .map((e) => {
                      "value": (e.depositeValue! - e.paymentAmount).toInt(),
                      "customerId": dataProvider.selectedCustomer?.customerId,
                      "paymentInvoiceId": e.issuedDeposite.paymentInvoiceId
                    })
                .toList()
          ]
        },
      );
      dataProvider.issuedDepositePaidList.forEach((element) async {
        final data = {
          "value": element.paymentAmount,
          "paymentInvoiceId": element.issuedDeposite.paymentInvoiceId,
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "creditInvoiceId":
              invoiceResponse.data['invoice']['invoiceId'] as int,
          "receiptNo": element.issuedDeposite.receiptNo,
          "status": 1
        };
        await respo('credit-payment/create', method: Method.post, data: data);
      });
      await respo(
        'customers/update',
        method: Method.put,
        data: {
          "customerId": selectedCustomer.customerId,
          "depositBalance": selectedCustomer.depositBalance -
              dataProvider.issuedDepositePaidList
                  .map((e) => e.paymentAmount)
                  .reduce((value, element) => value + element),
        },
      );
    }

    if (isOnlySave ?? false) {
      dataProvider.issuedDepositePaidList.clear();
    }

//! Create invoice
    await respo(
      'invoice/update',
      method: Method.put,
      data: {
        "invoiceId": invoiceResponse.data['invoice']['invoiceId'] as int,
        "status": balance < 0 ? 1 : 2,
        "creditValue": balance < 0 ? -balance : 0.0
      },
    );
    if (isOnlySave ?? false) {
      dataProvider.itemList.clear();
    }

    //! Create receipt number
    String? rn;
    if (receiptNo != null) {
      rn = receiptNo;
    } else {
      rn = await getReceiptNumber(context);
    }
    final invoiceId = invoiceResponse.data['invoice']['invoiceId'] as int;
    if (totalPayment != 0.0) {
      //! Create payment
      await respo(
        'payment/create',
        data: Payments(
          payments: [
            if (cash > 0)
              Payment(
                customerTypeId: selectedCustomer.customerTypeId,
                invoiceId: invoiceId,
                amount: cash,
                receiptNo: rn,
                paymentMethod: 1,
                chequeNo: null,
                routecardId: dataProvider.currentRouteCard!.routeCardId,
                routeId: dataProvider.currentRouteCard!.routeId,
                customerId: selectedCustomer.customerId,
                priceLevelId: selectedCustomer.priceLevelId,
                employeeId: dataProvider.currentEmployee!.employeeId,
                status: 1,
              ).toJson(),
            ...dataProvider.chequeList.map(
              (cheque) => Payment(
                customerTypeId: selectedCustomer.customerTypeId,
                invoiceId: invoiceId,
                amount: cheque.chequeAmount,
                chequeNo: cheque.chequeNumber,
                receiptNo: rn!,
                paymentMethod: 2,
                routecardId: dataProvider.currentRouteCard!.routeCardId,
                routeId: dataProvider.currentRouteCard!.routeId,
                customerId: selectedCustomer.customerId,
                priceLevelId: selectedCustomer.priceLevelId,
                employeeId: dataProvider.currentEmployee!.employeeId,
                status: 1,
              ).toJson(),
            ),
          ],
        ).toJson(),
        method: Method.post,
      );

      //! Create voucher payment
      if (dataProvider.selectedVoucher != null) {
        await respo(
          'payment/create',
          method: Method.post,
          data: Payments(
            payments: [
              if (cash > 0)
                Payment(
                  customerTypeId: selectedCustomer.customerTypeId,
                  invoiceId: invoiceId,
                  amount: dataProvider.selectedVoucher != null
                      ? dataProvider.selectedVoucher!.value
                      : 0.0,
                  chequeNo: dataProvider.selectedVoucher != null
                      ? dataProvider.selectedVoucher!.code
                      : null,
                  receiptNo: rn,
                  paymentMethod: 3,
                  routecardId: dataProvider.currentRouteCard!.routeCardId,
                  routeId: dataProvider.currentRouteCard!.routeId,
                  customerId: selectedCustomer.customerId,
                  priceLevelId: selectedCustomer.priceLevelId,
                  employeeId: dataProvider.currentEmployee!.employeeId,
                  status: 1,
                ).toJson(),
            ],
          ).toJson(),
        );
      }

      //! Add credit bill
      if (balance < 0) {
        await respo(
          'customer-credit/create',
          method: Method.post,
          data: {
            "value": balance * -1,
            "invoiceId": invoiceId,
            "customerId": selectedCustomer.customerId,
            "status": 1,
          },
        );
      }
    }
    if (balance > 0) {
      await respo(
        'customers/update',
        method: Method.put,
        data: {
          "customerId": selectedCustomer.customerId,
          "depositBalance": selectedCustomer.depositBalance + balance,
        },
      );
      await respo(
        'over-payment/create',
        method: Method.post,
        data: {
          "value": balance,
          "status": 1,
          "paymentInvoiceId": invoiceId,
          "routecardId": dataProvider.currentRouteCard!.routeCardId,
          "receiptNo": rn,
          "customerId": selectedCustomer.customerId
        },
      );
    }
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    invoiceProvider.invoiceNu = null;
    invoiceProvider.invoiceRes = null;
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}
