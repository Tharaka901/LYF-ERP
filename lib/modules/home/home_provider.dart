import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsr/models/payment_data/payment_data_model.dart';
import 'package:gsr/models/route_card/route_card_model.dart';
import 'package:gsr/services/invoice_service.dart';
import 'package:gsr/services/route_card_service.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/customer/customer_model.dart';
import '../../models/local_db_models/6_customer_deposites_adapter.dart';
import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import '../route_card/pending_rc_screen.dart';
import '../../services/customer_service.dart';
import '../../services/item_service.dart';
import '../../services/payment_service.dart';
import '../../services/stock_service.dart';

class HomeProvider extends ChangeNotifier {
  final RouteCardService routeCardService;
  final customerService = CustomerService();
  final paymentService = PaymentService();
  final invoiceService = InvoiceService();
  final itemService = ItemService();
  final stockService = StockService();

  List<RouteCardModel>? pendingRouteCards;

  bool isSyncingFromDB = false;
  bool isLoadingRouteCards = false;

  HomeProvider({required this.routeCardService});

  Future<void> getPendingRouteCards(BuildContext context) async {
    isLoadingRouteCards = true;
    notifyListeners();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);

    try {
      if (hiveDBProvider.isInternetConnected) {
        pendingRouteCards =
            await routeCardService.getPendingAndAcceptedRouteCards(
                dataProvider.currentEmployee!.employeeId!);
      } else {
        pendingRouteCards = hiveDBProvider.routeCardBox?.values.toList() ?? [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing route cards: $e');
      }
    } finally {
      isLoadingRouteCards = false;
      notifyListeners();
    }
  }

  Future<void> onPressedPendingRouteCardsButton(BuildContext context) async {
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        PendingRCScreen.routeId,
      );
    }
  }

  Future<void> onPreesedSyncDataFromDBButton(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      waiting(context, body: 'Sync...');

      int currentRouteCardId = 0;
      try {
        //! Clear data
        await hiveDBProvider.customerDepositeBox!.clear();
        await hiveDBProvider.customerCreditBox!.clear();

        //! Get pending route cards
        final pendingRouteCards =
            (await routeCardService.getPendingAndAcceptedRouteCards(
                    dataProvider.currentEmployee!.employeeId!))
                .where((r) => r.status == 1)
                .toList();
        //! Save route card data in local DB
        currentRouteCardId = pendingRouteCards[0].routeCardId!;
        final routeCardDataMap = {
          for (var e in pendingRouteCards) e.routeCardId: e
        };
        await hiveDBProvider.routeCardBox!.clear();
        await hiveDBProvider.routeCardBox!.putAll(routeCardDataMap);
        if (kDebugMode) {
          print('routeCardDataMap: $routeCardDataMap');
        }

        //! Get customers
        List<CustomerModel>? customers;
        customers = await customerService.getCustomers("",
            routeId: pendingRouteCards[0].routeId);
        //! Save customers data in local DB
        final customersDataMap = {for (var e in customers) e.customerId: e};
        await hiveDBProvider.customersBox!.clear();
        await hiveDBProvider.customersBox!.putAll(customersDataMap);
        if (kDebugMode) {
          print('customersDataMap: $customersDataMap');
        }
        for (final customer in customers) {
          //!Save customer deposites data in local DB
          if (context.mounted) {
            final deposites = await customerService.getCustomerDeposites(
              context,
              routecardId: currentRouteCardId,
              cId: customer.customerId,
            );
            final customerDeposites =
                CustomerDepositsModel(deposits: deposites);
            await hiveDBProvider.customerDepositeBox!
                .put(customer.customerId, customerDeposites);
            if (kDebugMode) {
              print('customer deposites: ${deposites.length}');
            }
          }
          //! Save customer credit invoice in local DB
          if (context.mounted) {
            final credits = await invoiceService.getCreditInvoices(context,
                cId: customer.customerId, type: 'with-cheque', invoiceId: 0);
            await hiveDBProvider.customerCreditBox!
                .put(customer.customerId, credits);
            if (kDebugMode) {
              print('customer credits: ${credits.length}');
            }
          }
        }

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
        for (final id in priceLevelIdList) {
          final basicItemList = (await itemService.getItemsByRoutecard(
            routeCardId: pendingRouteCards[0].routeCardId!,
            priceLevelId: id,
            type: '',
          ))
              .where((element) => (element.transferQty - element.sellQty) != 0)
              .toList();
          final newItemsList = await itemService.getNewItems(
            routeCardId: currentRouteCardId,
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
            if (kDebugMode) {
              print('basicItemList: ${basicItemList.length}');
              print('newItems: ${newItems.length}');
              print('otherItems: ${otherItems.length}');
            }
          } catch (e) {
            if (kDebugMode) {
              print(e.toString());
            }
          }
        }

        //! Save route card item in local DB
        final routeCardItemsSummary = await routeCardService.getRouteCardItems(
          currentRouteCardId,
        );
        await hiveDBProvider.routeCardIssuedItemsBox!.clear();
        await hiveDBProvider.routeCardIssuedItemsBox!
            .put(currentRouteCardId, routeCardItemsSummary);
        if (kDebugMode) {
          print('routeCardItemsSummary: ${routeCardItemsSummary.length}');
        }
        //! Save route card sold items in local DB
        final routeCardSoldItems = await routeCardService.getRouteCardSoldItems(
          routeCardId: currentRouteCardId,
        );
        await hiveDBProvider.routeCardSoldItemsBox!.clear();
        await hiveDBProvider.routeCardSoldItemsBox!
            .put(currentRouteCardId, routeCardSoldItems);
        if (kDebugMode) {
          print('routeCardSoldItems: ${routeCardSoldItems.length}');
        }
        //!Get invoice count and save to local DB
        int invoiceCount = await invoiceService
            .invoiceCount(pendingRouteCards[0].routeCardId!);
        int invoiceCountLocalDb = hiveDBProvider.invoiceBox!.length;
        await hiveDBProvider.dataBox!.put(
            'invoiceCount', (invoiceCount + invoiceCountLocalDb).toString());
        if (kDebugMode) {
          print('invoiceCount: $invoiceCount');
          print('invoiceCountLocalDb: $invoiceCountLocalDb');
        }
        //!Get receipt count and save to local DB
        int receiptCount = await paymentService
            .getReceiptCount(pendingRouteCards[0].routeCardId!);
        int receiptCountLocalDb = hiveDBProvider.paymentsBox!.length;
        await hiveDBProvider.dataBox!.put(
            'receiptCount', (receiptCount + receiptCountLocalDb).toString());
        if (kDebugMode) {
          print('receiptCount: $receiptCount');
          print('receiptCountLocalDb: $receiptCountLocalDb');
        }
        //! Save loan items to local DB
        final loanItems = await routeCardService
            .getRouteCardSoldLoanItems(pendingRouteCards[0].routeCardId!);
        await hiveDBProvider.routeCardSoldLoanItemsBox!.clear();
        await hiveDBProvider.routeCardSoldLoanItemsBox!
            .put(currentRouteCardId, loanItems);
        if (kDebugMode) {
          print('loanItems: ${loanItems.length}');
        }
        //! Save sold leak items to local DB
        final soldLeakItems = await routeCardService
            .getRouteCardSoldLeakItems(pendingRouteCards[0].routeCardId!);
        await hiveDBProvider.routeCardSoldLeakItemsBox!.clear();
        await hiveDBProvider.routeCardSoldLeakItemsBox!
            .put(currentRouteCardId, soldLeakItems);
        if (kDebugMode) {
          print('soldLeakItems: ${soldLeakItems.length}');
        }
        //! Save return cylinder summary customer wise leak to local DB
        final returnCylinderSummaryCustomerWiseLeak =
            await routeCardService.getReturnCylinderSummaryCustomerWiseLeak(
                pendingRouteCards[0].routeCardId!);
        await hiveDBProvider.returnCylinderSummaryCustomerWiseLeakBox!.clear();
        await hiveDBProvider.returnCylinderSummaryCustomerWiseLeakBox!
            .put(currentRouteCardId, returnCylinderSummaryCustomerWiseLeak);
        if (kDebugMode) {
          print('returnCylinderSummaryCustomerWiseLeak: ${returnCylinderSummaryCustomerWiseLeak.length}');
        }
        if (context.mounted) {
          pop(context);
        }
        toast(
          'Success',
          toastState: TS.success,
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        if (context.mounted) {
          pop(context);
          toast(
            e.toString(),
            toastState: TS.error,
          );
        }
      }
    }
  }

  Future<void> onPressedSyncDataToDBButton(BuildContext context) async {
    waiting(context, body: 'Sync...');
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    if (hiveDBProvider.isInternetConnected) {
      //   await hiveDBProvider.invoiceBox!.clear();
      // await hiveDBProvider.paymentsBox!.clear();
      try {
        final invoiceBox = hiveDBProvider.invoiceBox!;
        final paymentsBox = hiveDBProvider.paymentsBox!;
        // Iterate by invoice box KEY so we use the same key for payment lookup
        // (offline payments are stored under invoice number = box key)
        for (final invoiceNoKey in invoiceBox.keys) {
          final invoice = invoiceBox.get(invoiceNoKey);
          if (invoice == null) continue;
          final invoiceRes = await invoiceService.createInvoice({
            "invoice": invoice.toJson(),
            "invoiceItems": invoice.invoiceItems
          });
          final data = invoiceRes.data;
          final responseInvoiceNo = data is Map
              ? (data['invoice'] is Map
                  ? (data['invoice'] as Map)['invoiceNo']?.toString()
                  : data['invoiceNo']?.toString())
              : null;
          final responseInvoiceId = data is Map
              ? (data['invoice'] is Map
                  ? ((data['invoice'] as Map)['invoiceId'] ??
                      (data['invoice'] as Map)['id'])
                  : (data['invoiceId'] ?? data['id']))
              : null;
          int? responseId;
          if (responseInvoiceId is int) {
            responseId = responseInvoiceId;
          } else if (responseInvoiceId != null) {
            responseId = int.tryParse(responseInvoiceId.toString());
          }
          PaymentDataModel? paymentData = paymentsBox.get(invoiceNoKey.toString().trim());
          if (paymentData == null) {
            paymentData = paymentsBox.get(invoice.invoiceNo.trim());
          }
          if (paymentData == null && responseInvoiceNo != null) {
            paymentData = paymentsBox.get(responseInvoiceNo);
          }
          if (paymentData == null) {
            for (final key in paymentsBox.keys) {
              final pd = paymentsBox.get(key);
              if (pd != null &&
                  (key == invoiceNoKey ||
                      key == invoice.invoiceNo ||
                      pd.invoiceNo == invoice.invoiceNo)) {
                paymentData = pd;
                break;
              }
            }
          }
          if (paymentData != null && responseId != null) {
            paymentData.invoiceId = responseId;
            paymentData.invoiceNo = responseInvoiceNo ?? invoice.invoiceNo;
            final hasPreviousPayments =
                (paymentData.issuedInvoicePaidList ?? []).isNotEmpty;
            final isDirectPrevious = paymentData.isDirectPrevoius ?? true;
            if (hasPreviousPayments && isDirectPrevious) {
              if (context.mounted) {
                await paymentService.payWithCreditInvoice(
                  context: context,
                  paymentDataModel: paymentData,
                );
              }
            } else if (paymentData.isDirectPrevoius == false) {
              if (context.mounted) {
                await paymentService.sendCreditPayment(context, paymentData);
              }
            } else {
              if (context.mounted) {
                await paymentService.pay(
                  context: context,
                  paymentDataModel: paymentData,
                );
              }
            }
          }
        }
        await hiveDBProvider.invoiceBox!.clear();
        await hiveDBProvider.paymentsBox!.clear();
        if (context.mounted) {
          pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          pop(context);
        }
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      pop(context);
    }
  }
}
