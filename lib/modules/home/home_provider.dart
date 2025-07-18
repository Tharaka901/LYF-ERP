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
import '../../screens/pending_rc_screen.dart';
import '../../services/customer_service.dart';
import '../../services/item_service.dart';
import '../../services/payment_service.dart';
import '../stock/enum.dart';

class HomeProvider extends ChangeNotifier {
  final RouteCardService routeCardService;
  final customerService = CustomerService();
  final paymentService = PaymentService();
  final invoiceService = InvoiceService();
  final itemService = ItemService();

  List<RouteCardModel>? pendingRouteCards;

  bool isSyncingFromDB = false;

  HomeProvider({required this.routeCardService});

  Future<void> onPressedPendingRouteCardsButton(BuildContext context) async {
    waiting(context, body: 'Checking...');
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);

    if (hiveDBProvider.isInternetConnected) {
      pendingRouteCards =
          await routeCardService.getPendingAndAcceptedRouteCards(
              dataProvider.currentEmployee!.employeeId!);
    } else {
      pendingRouteCards = hiveDBProvider.routeCardBox?.values.toList() ?? [];
    }
    if (context.mounted) {
      pop(context);
    }
    if (pendingRouteCards!.isNotEmpty) {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          PendingRCScreen.routeId,
        );
      }
    } else {
      toast(
        'No routecards available',
        toastState: TS.error,
      );
    }
  }

  Future<void> onPreesedSyncDataFromDBButton(BuildContext context) async {
    waiting(context, body: 'Sync...');
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    int currentRouteCardId = 0;

    if (hiveDBProvider.isInternetConnected) {
      try {
        //! Clear data
        await hiveDBProvider.customerDepositeBox!.clear();
        await hiveDBProvider.customerCreditBox!.clear();

        //! Get pending route cards
        final pendingRouteCards =
            await routeCardService.getPendingAndAcceptedRouteCards(
                dataProvider.currentEmployee!.employeeId!);
        //! Save route card data in local DB
        currentRouteCardId = pendingRouteCards[0].routeCardId!;
        final routeCardDataMap = {
          for (var e in pendingRouteCards) e.routeCardId: e
        };

        await hiveDBProvider.routeCardBox!.clear();
        await hiveDBProvider.routeCardBox!.putAll(routeCardDataMap);

        //! Get customers
        List<CustomerModel>? customers;
        customers = await customerService.getCustomers("",
            routeId: pendingRouteCards[0].routeId);
        //! Save customers data in local DB
        final customersDataMap = {for (var e in customers) e.customerId: e};
        await hiveDBProvider.customersBox!.clear();
        await hiveDBProvider.customersBox!.putAll(customersDataMap);

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
          }
          //! Save customer credit invoice in local DB
          if (context.mounted) {
            final credits = await invoiceService.getCreditInvoices(context,
                cId: customer.customerId, type: 'with-cheque', invoiceId: 0);
            await hiveDBProvider.customerCreditBox!
                .put(customer.customerId, credits);
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

        //! Save route card sold items in local DB
        final routeCardSoldItems = await routeCardService.getRouteCardSoldItems(
          routeCardId: currentRouteCardId,
        );
        await hiveDBProvider.routeCardSoldItemsBox!.clear();
        await hiveDBProvider.routeCardSoldItemsBox!
            .put(currentRouteCardId, routeCardSoldItems); 

        //!Get invoice count and save to local DB
        int invoiceCount = await invoiceService
            .invoiceCount(pendingRouteCards[0].routeCardId!);
        int invoiceCountLocalDb = hiveDBProvider.invoiceBox!.length;
        await hiveDBProvider.dataBox!.put(
            'invoiceCount', (invoiceCount + invoiceCountLocalDb).toString());

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
        for (final invoice in hiveDBProvider.invoiceBox!.values) {
          final invoiceRes = await invoiceService.createInvoice({
            "invoice": invoice.toJson(),
            "invoiceItems": invoice.invoiceItems
          });
          PaymentDataModel? paymentData = hiveDBProvider.paymentsBox!
              .get(invoiceRes.data['invoice']['invoiceNo']);
          paymentData?.invoiceId = invoiceRes.data['invoice']['invoiceId'];
          if (paymentData != null) {
            if ((paymentData.issuedInvoicePaidList ?? []).isNotEmpty &&
                paymentData.isDirectPrevoius!) {
              if (context.mounted) {
                await paymentService.payWithCreditInvoice(
                  context: context,
                  paymentDataModel: paymentData,
                );
              }
            } else if (!paymentData.isDirectPrevoius!) {
              paymentData.invoiceNo = invoiceRes.data['invoice']['invoiceNo'];
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
