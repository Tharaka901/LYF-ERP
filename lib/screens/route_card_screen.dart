import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/commons/enums.dart';
import 'package:gsr/models/item_summary.dart' as item_summary;
import 'package:gsr/models/item_summary_customer_wise/item_summary_customer_wise.dart' as item_summary_cw;
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/loan_stock/loan_stock.dart' as loan_stock;
import 'package:gsr/models/route_card_item/rc_sold_loan_items_model.dart';
import 'package:gsr/models/route_card_item/route_card_item_model.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/providers/hive_db_provider.dart';
import 'package:gsr/modules/route_card/about_rc_screen.dart';
import 'package:gsr/screens/invoice_summary_screen.dart';
import 'package:gsr/screens/overall_summary_screen.dart';
import 'package:gsr/modules/previous_customer_select/previous_screen.dart';
import 'package:gsr/screens/rc_summary_screen.dart';
import 'package:gsr/modules/select_customer/select_customer_screen.dart';
import 'package:gsr/modules/stock/stock_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

class RouteCardScreen extends StatefulWidget {
  static const routeId = 'ROUTE_CARD';
  const RouteCardScreen({super.key});

  @override
  State<RouteCardScreen> createState() => _RouteCardScreenState();
}

class _RouteCardScreenState extends State<RouteCardScreen> {
  // Helper function to get ItemSummary from local DB
  List<item_summary.ItemSummary> getItemSummaryFromLocal(
      HiveDBProvider hiveDBProvider, int routeCardId) {
    final box = hiveDBProvider.routeCardIssuedItemsBox;
    final raw = box?.get(routeCardId) ?? [];
    final List<RouteCardItemModel> items =
        (raw).map((e) => e as RouteCardItemModel).toList();

    // Convert RouteCardItemModel to ItemSummary
    return items.map((item) {
      return item_summary.ItemSummary(
        selQty: item.sellQty.toString(),
        itemId: item.itemId,
        item: item.item != null
            ? item_summary.Item(
                id: item.item!.id,
                itemName: item.item!.itemName,
                itemRegNo: item.item!.itemRegNo,
                costPrice: item.item!.costPrice,
                salePrice: item.item!.salePrice,
                openingQty: item.item!.openingQty?.toInt(),
                vendorId: item.item!.vendorId,
                priceLevelId: item.item!.priceLevelId,
                itemTypeId: item.item!.itemTypeId,
                stockId: item.item!.stockId,
                costAccId: item.item!.costAccId,
                incomeAccId: item.item!.incomeAccId,
                status: item.item!.status,
                isNew: item.item!.isNew,
                itemId: item.item!.itemId,
              )
            : null,
        invoice: null,
      );
    }).toList();
  }

  // Helper function to get ItemSummaryCustomerWise from local DB for loan
  List<item_summary_cw.ItemSummaryCustomerWise> getItemSummaryCustomerWiseFromLocal(
      HiveDBProvider hiveDBProvider, int routeCardId) {
    final box = hiveDBProvider.routeCardSoldLoanItemsBox;
    final raw = box?.get(routeCardId) ?? [];
    final List<RouteCardSoldLoanItemModel> loanItems =
        (raw).map((e) => e as RouteCardSoldLoanItemModel).toList();

    // Get invoices from local DB
    final invoiceBox = hiveDBProvider.invoiceBox;
    final List<InvoiceModel> invoices = invoiceBox?.values
            .where((invoice) => invoice.routecardId == routeCardId)
            .toList() ??
        [];

    // Convert RouteCardSoldLoanItemModel to ItemSummaryCustomerWise
    final List<item_summary_cw.ItemSummaryCustomerWise> result = [];
    for (var loanItem in loanItems) {
      // Find invoices for this item (status 3 = issued, status 2 = received)
      final issuedInvoices = invoices.where((inv) =>
          inv.status == 3 &&
          inv.invoiceItems?.any((item) => item.itemId == loanItem.itemId) ==
              true);
      final receivedInvoices = invoices.where((inv) =>
          inv.status == 2 &&
          inv.invoiceItems?.any((item) => item.itemId == loanItem.itemId) ==
              true);

      // Add issued items
      for (var invoice in issuedInvoices) {
        final invoiceItem = invoice.invoiceItems?.firstWhere(
            (item) => item.itemId == loanItem.itemId,
            orElse: () => invoice.invoiceItems!.first);
        result.add(item_summary_cw.ItemSummaryCustomerWise(
          selQty: loanItem.issuedStock.toString(),
          itemId: loanItem.itemId,
          status: 3,
          invoice: invoiceItem != null
              ? item_summary_cw.Invoice(
                  id: invoice.invoiceId,
                  invoiceNo: invoice.invoiceNo,
                  routecardId: invoice.routecardId,
                  customerId: invoice.customerId,
                  employeeId: invoice.employeeId,
                  status: invoice.status,
                  createdAt: invoice.createdAt,
                  customer: invoice.customer != null
                      ? item_summary_cw.Customer(
                          customerId: invoice.customer!.customerId,
                          businessName: invoice.customer!.businessName,
                          registrationId: invoice.customer!.registrationId,
                          dealerCode: invoice.customer!.dealerCode,
                          parentCompany: invoice.customer!.parentCompany,
                          ownerName: invoice.customer!.ownerName,
                          address: invoice.customer!.address,
                          contactNumber: invoice.customer!.contactNumber,
                          homeDelivery: invoice.customer!.homeDelivery,
                          creditLimit: invoice.customer!.creditLimit,
                          paymentMethodId: invoice.customer!.paymentMethodId,
                          customerTypeId: invoice.customer!.customerTypeId,
                          priceLevelId: invoice.customer!.priceLevelId,
                          routeId: invoice.customer!.routeId,
                          employeeId: invoice.customer!.employeeId,
                          depositBalance: invoice.customer!.depositBalance,
                          status: invoice.customer!.status,
                        )
                      : null,
                )
              : null,
          item: item_summary_cw.Item(
            id: loanItem.item.id,
            itemName: loanItem.item.itemName,
            itemRegNo: loanItem.item.itemRegNo,
                costPrice: loanItem.item.costPrice?.toDouble(),
                salePrice: loanItem.item.salePrice?.toDouble(),
            openingQty: loanItem.item.openingQty?.toInt(),
            vendorId: loanItem.item.vendorId,
            priceLevelId: loanItem.item.priceLevelId,
            itemTypeId: loanItem.item.itemTypeId,
            stockId: loanItem.item.stockId,
            costAccId: loanItem.item.costAccId,
            incomeAccId: loanItem.item.incomeAccId,
            status: loanItem.item.status,
            isNew: loanItem.item.isNew,
            itemId: loanItem.item.itemId,
          ),
        ));
      }

      // Add received items
      for (var invoice in receivedInvoices) {
        final invoiceItem = invoice.invoiceItems?.firstWhere(
            (item) => item.itemId == loanItem.itemId,
            orElse: () => invoice.invoiceItems!.first);
        result.add(item_summary_cw.ItemSummaryCustomerWise(
          selQty: loanItem.receivedStock.toString(),
          itemId: loanItem.itemId,
          status: 2,
          invoice: invoiceItem != null
              ? item_summary_cw.Invoice(
                  id: invoice.invoiceId,
                  invoiceNo: invoice.invoiceNo,
                  routecardId: invoice.routecardId,
                  customerId: invoice.customerId,
                  employeeId: invoice.employeeId,
                  status: invoice.status,
                  createdAt: invoice.createdAt,
                  customer: invoice.customer != null
                      ? item_summary_cw.Customer(
                          customerId: invoice.customer!.customerId,
                          businessName: invoice.customer!.businessName,
                          registrationId: invoice.customer!.registrationId,
                          dealerCode: invoice.customer!.dealerCode,
                          parentCompany: invoice.customer!.parentCompany,
                          ownerName: invoice.customer!.ownerName,
                          address: invoice.customer!.address,
                          contactNumber: invoice.customer!.contactNumber,
                          homeDelivery: invoice.customer!.homeDelivery,
                          creditLimit: invoice.customer!.creditLimit,
                          paymentMethodId: invoice.customer!.paymentMethodId,
                          customerTypeId: invoice.customer!.customerTypeId,
                          priceLevelId: invoice.customer!.priceLevelId,
                          routeId: invoice.customer!.routeId,
                          employeeId: invoice.customer!.employeeId,
                          depositBalance: invoice.customer!.depositBalance,
                          status: invoice.customer!.status,
                        )
                      : null,
                )
              : null,
          item: item_summary_cw.Item(
            id: loanItem.item.id,
            itemName: loanItem.item.itemName,
            itemRegNo: loanItem.item.itemRegNo,
                costPrice: loanItem.item.costPrice?.toDouble(),
                salePrice: loanItem.item.salePrice?.toDouble(),
            openingQty: loanItem.item.openingQty?.toInt(),
            vendorId: loanItem.item.vendorId,
            priceLevelId: loanItem.item.priceLevelId,
            itemTypeId: loanItem.item.itemTypeId,
            stockId: loanItem.item.stockId,
            costAccId: loanItem.item.costAccId,
            incomeAccId: loanItem.item.incomeAccId,
            status: loanItem.item.status,
            isNew: loanItem.item.isNew,
            itemId: loanItem.item.itemId,
          ),
        ));
      }
    }
    return result;
  }

  // Helper function to get ItemSummaryCustomerWise for leak from local DB
  List<item_summary_cw.ItemSummaryCustomerWise> getItemSummaryCustomerWiseLeakFromLocal(
      HiveDBProvider hiveDBProvider, int routeCardId) {
    final box = hiveDBProvider.routeCardSoldLeakItemsBox;
    final raw = box?.get(routeCardId) ?? [];
    final List<loan_stock.LoanStockModel> leakItems =
        (raw).map((e) => e as loan_stock.LoanStockModel).toList();

    // Convert LoanStockModel to ItemSummaryCustomerWise
    return leakItems.map((leakItem) {
      return item_summary_cw.ItemSummaryCustomerWise(
        selQty: leakItem.selQty,
        itemId: leakItem.itemId,
        status: leakItem.status,
        invoice: leakItem.invoice != null
            ? item_summary_cw.Invoice(
                id: leakItem.invoice!.id,
                invoiceNo: leakItem.invoice!.invoiceNo,
                routecardId: leakItem.invoice!.routecardId,
                customerId: leakItem.invoice!.customerId,
                employeeId: leakItem.invoice!.employeeId,
                status: leakItem.invoice!.status,
                createdAt: leakItem.invoice!.createdAt,
                customer: null, // LoanStockModel Invoice doesn't have customer
              )
            : null,
        item: leakItem.item != null
            ? item_summary_cw.Item(
                id: leakItem.item!.id,
                itemName: leakItem.item!.itemName,
                itemRegNo: leakItem.item!.itemRegNo,
                costPrice: leakItem.item!.costPrice?.toDouble(),
                salePrice: leakItem.item!.salePrice?.toDouble(),
                openingQty: leakItem.item!.openingQty,
                vendorId: leakItem.item!.vendorId,
                priceLevelId: leakItem.item!.priceLevelId,
                itemTypeId: leakItem.item!.itemTypeId,
                stockId: leakItem.item!.stockId,
                costAccId: leakItem.item!.costAccId,
                incomeAccId: leakItem.item!.incomeAccId,
                status: leakItem.item!.status,
                isNew: leakItem.item!.isNew,
                itemId: leakItem.item!.itemId,
              )
            : null,
      );
    }).toList();
  }

  // Helper function to get return cylinder summary from local DB
  List<item_summary_cw.ItemSummaryCustomerWise> getReturnCylinderSummaryCustomerWiseLeakFromLocal(
      HiveDBProvider hiveDBProvider, int routeCardId) {
    final box = hiveDBProvider.returnCylinderSummaryCustomerWiseLeakBox;
    final raw = box?.get(routeCardId) ?? [];
    final List<item_summary_cw.ItemSummaryCustomerWise> items =
        (raw).map((e) => e as item_summary_cw.ItemSummaryCustomerWise).toList();
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final routeCard = dataProvider.currentRouteCard;
    if (routeCard == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No Route Card')),
        body: const Center(
          child: Text('No current route card available'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${routeCard.route?.routeName} - ${date(routeCard.date ?? DateTime.now(), format: 'dd.MM.yyyy')}',
        ),
      ),
      floatingActionButton: Consumer<DataProvider>(
        builder: (context, data, _) => data.currentRouteCard?.status != 0
            ? FloatingActionButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  InvoiceSummaryScreen.routeId,
                ),
                child: const Icon(
                  Icons.summarize_rounded,
                  size: 40,
                ),
              )
            : dummy,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: defaultPadding,
          child: Consumer<DataProvider>(
            builder: (context, data, _) => Column(
              children: [
                OptionCard(
                  title: data.currentRouteCard!.status == 0
                      ? 'Accept or Reject this R/C'
                      : 'View this R/C',
                  titleFontSize: 25.0,
                  height: 15,
                  elevation: 2,
                  onTap: () async {
                    waiting(
                      context,
                      body: 'Receiving data...',
                    );
                    data.clearRCItems();
                    await getItemsByRoutecard(
                            routeCardId: routeCard.routeCardId!,
                            onlyRefill: false,
                            priceLevelId: 1,
                            type: data.currentRouteCard!.status == 0
                                ? ''
                                : 'rc-summary')
                        .then((rcItems) {
                      for (var element in rcItems) {
                        data.addRCItem(element);
                      }
                    }).then((value) {
                      if (!context.mounted) return;
                      pop(context);
                      Navigator.pushNamed(
                        context,
                        AboutRCScreen.routeId,
                      ).then((value) {
                        if (value != null) {
                          if (value == 1) {
                            if (!context.mounted) return;
                            waiting(context, body: 'Accepting Route Card...');
                            updateRouteCard(
                              routeCardId: data.currentRouteCard!.routeCardId!,
                              status: 1,
                            ).then((value) {
                              if (!context.mounted) return;
                              pop(context);
                              toast(
                                'Routecard ${data.currentRouteCard!.routeCardNo} accepted successfully',
                                toastState: TS.success,
                              );
                            });
                            data.acceptRouteCard();
                          }
                        }
                      });
                    });
                  },
                  enabled: hiveDBProvider.isInternetConnected,
                  trailing: data.currentRouteCard!.status == 0
                      ? const Icon(
                          Icons.question_mark_rounded,
                          size: 40,
                          color: defaultErrorColor,
                        )
                      : const Icon(
                          Icons.done_rounded,
                          size: 40,
                          color: defaultAcceptColor,
                        ),
                ),
                if (data.currentRouteCard?.status == 1) ...[
                  OptionCard(
                    title: 'Billing',
                    onTap: () => Navigator.pushNamed(
                      context,
                      SelectCustomerView.routeId,
                      arguments: {
                        //  'route_card': routeCard,
                      },
                    ).then((value) {
                      dataProvider.clearItemList();
                      dataProvider.clearChequeList();
                      dataProvider.clearRCItems();
                      dataProvider.clearPaidBalanceList();
                      dataProvider.setSelectedCustomer(null);
                      dataProvider.setSelectedVoucher(null);
                      dataProvider.setCurrentInvoice(null);
                    }),
                    enabled: data.currentRouteCard!.status == 1,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Manual Billing',
                    onTap: () => Navigator.pushNamed(
                      context,
                      SelectCustomerView.routeId,
                      arguments: {'route_card': routeCard, 'isManual': true},
                    ).then((value) {
                      dataProvider.clearItemList();
                      dataProvider.clearChequeList();
                      dataProvider.clearRCItems();
                      dataProvider.clearPaidBalanceList();
                      dataProvider.setSelectedCustomer(null);
                      dataProvider.setSelectedVoucher(null);
                      dataProvider.setCurrentInvoice(null);
                    }),
                    enabled: data.currentRouteCard!.status == 1,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Previous',
                    onTap: () => Navigator.pushNamed(
                      context,
                      PreviousScreen.routeId,
                    ).then((value) {
                      dataProvider.clearChequeList();
                      dataProvider.setSelectedCustomer(null);
                      dataProvider.setSelectedInvoice(null);
                      dataProvider.setSelectedVoucher(null);
                      dataProvider.clearPreviousInvoiceList();
                    }),
                    enabled: data.currentRouteCard!.status == 1,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Collection summary',
                    onTap: () => Navigator.pushNamed(
                      context,
                      OverallSummaryScreen.routeId,
                    ),
                    enabled: data.currentRouteCard!.status == 1 && hiveDBProvider.isInternetConnected,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Loan',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCustomerView(
                                type: 'Loan',
                              )),
                    ).then((value) {
                      dataProvider.clearItemList();
                      dataProvider.clearChequeList();
                      dataProvider.clearRCItems();
                      dataProvider.clearPaidBalanceList();
                      dataProvider.setSelectedCustomer(null);
                      dataProvider.setSelectedVoucher(null);
                      dataProvider.setCurrentInvoice(null);
                    }),
                    enabled: hiveDBProvider.isInternetConnected,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Return Cylinders',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCustomerView(
                                type: 'Return',
                                featureType: AppFeatureType.returnCylinder,
                              )),
                    ).then((value) {
                      dataProvider.clearItemList();
                      dataProvider.clearChequeList();
                      dataProvider.clearRCItems();
                      dataProvider.clearPaidBalanceList();
                      dataProvider.setSelectedCustomer(null);
                      dataProvider.setSelectedVoucher(null);
                      dataProvider.setCurrentInvoice(null);
                    }),
                    enabled: hiveDBProvider.isInternetConnected,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Leak',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCustomerView(
                                type: 'Leak',
                              )),
                    ).then((value) {
                      dataProvider.clearItemList();
                      dataProvider.clearChequeList();
                      dataProvider.clearRCItems();
                      dataProvider.clearPaidBalanceList();
                      dataProvider.setSelectedCustomer(null);
                      dataProvider.setSelectedVoucher(null);
                      dataProvider.setCurrentInvoice(null);
                    }),
                     enabled: hiveDBProvider.isInternetConnected,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Sales Summary',
                    onTap: () async {
                      waiting(
                        context,
                        body: 'Receiving data...',
                      );
                      List<item_summary.ItemSummary> itemSummary;
                      List<item_summary_cw.ItemSummaryCustomerWise> itemSummaryCW;
                      List<item_summary_cw.ItemSummaryCustomerWise> itemSummaryCWLeak;
                      List<item_summary_cw.ItemSummaryCustomerWise> itemSummaryCWReturnC;

                      if (hiveDBProvider.isInternetConnected) {
                        // Fetch from API when online
                        itemSummary =
                            await getItemSummary(routeCard.routeCardId!);
                        itemSummaryCW = await getItemSummaryCustomerWise(
                            routeCard.routeCardId!);
                        itemSummaryCWLeak =
                            await getItemSummaryCustomerWiseLeak(
                                routeCard.routeCardId!);
                        itemSummaryCWReturnC =
                            await getReturnCylinderSummaryCustomerWiseLeak(
                                routeCard.routeCardId!,
                                isCustomerWise: true);
                      } else {
                        // Fetch from local DB when offline
                        itemSummary = getItemSummaryFromLocal(
                            hiveDBProvider, routeCard.routeCardId!);
                        itemSummaryCW = getItemSummaryCustomerWiseFromLocal(
                            hiveDBProvider, routeCard.routeCardId!);
                        itemSummaryCWLeak = getItemSummaryCustomerWiseLeakFromLocal(
                            hiveDBProvider, routeCard.routeCardId!);
                        itemSummaryCWReturnC =
                            getReturnCylinderSummaryCustomerWiseLeakFromLocal(
                                hiveDBProvider, routeCard.routeCardId!);
                      }
                      if (!context.mounted) return;
                      pop(context);
                      final List<item_summary_cw.ItemSummaryCustomerWiseFull> li = [];
                      final List<item_summary_cw.ItemSummaryCustomerWiseFull> liLeak = [];
                      final List<item_summary_cw.ItemSummaryCustomerWiseFull> liRC = [];
                      for (var element1 in itemSummaryCW) {
                        for (var element2 in itemSummaryCW) {
                          if (element1.item?.itemName ==
                                  element2.item?.itemName &&
                              element1.invoice?.customer?.businessName ==
                                  element2.invoice?.customer?.businessName &&
                              element1.invoice?.status !=
                                  element2.invoice?.status) {
                            if (!(li.map((e) => e.customerName).contains(
                                    element1.invoice?.customer?.businessName) &&
                                li
                                    .map((e) => e.itemName)
                                    .contains(element1.item?.itemName ?? ''))) {
                              li.add(item_summary_cw.ItemSummaryCustomerWiseFull(
                                  customerName:
                                      element1.invoice?.customer?.businessName,
                                  itemName: element1.item?.itemName,
                                  recivedQty: element1.invoice?.status == 2
                                      ? int.parse(element1.selQty ?? '0')
                                      : int.parse(element2.selQty ?? '0'),
                                  issuedQty: element2.invoice?.status == 3
                                      ? int.parse(element2.selQty ?? '0')
                                      : int.parse(element1.selQty ?? '0'),
                                  unique: (element1
                                          .invoice?.customer?.businessName ?? '') +
                                      (element1.item?.itemName ?? '')));
                            }
                          }
                        }
                        if (!(li.map((e) => e.unique).contains(
                            (element1.invoice?.customer?.businessName ?? '') +
                                (element1.item?.itemName ?? '')))) {
                          li.add(item_summary_cw.ItemSummaryCustomerWiseFull(
                              customerName:
                                  element1.invoice?.customer?.businessName,
                              itemName: element1.item?.itemName,
                              recivedQty: element1.invoice?.status == 2
                                  ? int.parse(element1.selQty ?? '0')
                                  : 0,
                              issuedQty: element1.invoice?.status == 3
                                  ? int.parse(element1.selQty ?? '0')
                                  : 0,
                              unique:
                                  (element1.invoice?.customer?.businessName ?? '') +
                                      (element1.item?.itemName ?? '')));
                        }
                      }

                      for (var element1 in itemSummaryCWLeak) {
                        liLeak.add(item_summary_cw.ItemSummaryCustomerWiseFull(
                            customerName:
                                element1.invoice?.customer?.businessName,
                            itemName: element1.item?.itemName,
                            recivedQty: element1.invoice?.status == 2 &&
                                    element1.item?.itemTypeId != 7
                                ? int.parse(element1.selQty ?? '0')
                                : 0,
                            issuedQty: element1.status == 6 &&
                                    element1.item?.itemTypeId == 7
                                ? int.parse(element1.selQty ?? '0')
                                : 0,
                            unique:
                                (element1.invoice?.customer?.businessName ?? '') +
                                    (element1.item?.itemName ?? '')));
                      }
                      for (var element1 in itemSummaryCWReturnC) {
                        liRC.add(item_summary_cw.ItemSummaryCustomerWiseFull(
                            customerName:
                                element1.invoice?.customer?.businessName,
                            itemName: element1.item?.itemName,
                            recivedQty: int.parse(element1.selQty ?? '0'),
                            issuedQty: 0,
                            unique: ''));
                      }
                      if (!context.mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RCSummaryScreen(
                                  itemSummary: itemSummary,
                                  itemSummaryCW: li,
                                  itemSummaryCWLeak: liLeak,
                                  itemSummaryCWReturnC: liRC)));
                    },
                    enabled: true,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Stock',
                    onTap: () async {
                      waiting(
                        context,
                        body: 'Receiving data...',
                      );

                      data.clearRCItems();

                      // final rcItems = await getItemsByRoutecard(
                      //   routeCardId: routeCard.routeCardId!,
                      //   onlyRefill: false,
                      //   priceLevelId: 1,
                      //   type: data.currentRouteCard!.status == 0
                      //       ? ''
                      //       : 'rc-summary',
                      // );

                      // if (!context.mounted) return;

                      // for (var element in rcItems) {
                      //   if (element.item?.itemTypeId != 5) {
                      //     data.addRCItem(element);
                      //   }
                      // }

                      // final rcItemSummary = await getItemsSummaryByRoutecard(
                      //   routeCardId: routeCard.routeCardId!,
                      // );

                      if (!context.mounted) return;

                      pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockScreen(),
                        ),
                      );
                    },
                    enabled: data.currentRouteCard!.status == 1 && hiveDBProvider.isInternetConnected,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
