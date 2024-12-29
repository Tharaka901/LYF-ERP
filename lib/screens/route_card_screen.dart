import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/item_summary_customer_wise.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/about_rc_screen.dart';
import 'package:gsr/screens/invoice_summary_screen.dart';
import 'package:gsr/screens/overall_summary_screen.dart';
import 'package:gsr/screens/previous_screen.dart';
import 'package:gsr/screens/rc_summary_screen.dart';
import 'package:gsr/screens/select_customer_screen.dart';
import 'package:gsr/screens/stock_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

class RouteCardScreen extends StatefulWidget {
  static const routeId = 'ROUTE_CARD';
  const RouteCardScreen({Key? key}) : super(key: key);

  @override
  State<RouteCardScreen> createState() => _RouteCardScreenState();
}

class _RouteCardScreenState extends State<RouteCardScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCard = dataProvider.currentRouteCard!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${routeCard.route.routeName} -${routeCard.date}',
        ),
      ),
      floatingActionButton: Consumer<DataProvider>(
        builder: (context, data, _) => data.currentRouteCard!.status != 0
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
                            routeCardId: routeCard.routeCardId,
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
                      pop(context);
                      Navigator.pushNamed(
                        context,
                        AboutRCScreen.routeId,
                      ).then((value) {
                        if (value != null) {
                          if (value == 1) {
                            waiting(context, body: 'Accepting Route Card...');
                            updateRouteCard(
                              routeCardId: data.currentRouteCard!.routeCardId,
                              status: 1,
                            ).then((value) {
                              pop(context);
                              toast(
                                'Routecard ${data.currentRouteCard!.routeCardNo} accepted successfully',
                                toastState: TS.success,
                              );
                            });
                            data.acceptRouteCard();
                          }
                          if (value == 4) {
                            waiting(context, body: 'Rejecting Route Card...');
                            updateRouteCard(
                              routeCardId: data.currentRouteCard!.routeCardId,
                              status: 4,
                            ).then((value) {
                              pop(context);
                              pop(context);
                              toast(
                                'Routecard ${data.currentRouteCard!.routeCardNo} rejected successfully',
                                toastState: TS.success,
                              );
                            });
                            data.rejectRouteCard();
                          }
                        }
                      });
                    });
                  },
                  enabled: true,
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
                      SelectCustomerScreen.routeId,
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
                      SelectCustomerScreen.routeId,
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
                    enabled: data.currentRouteCard!.status == 1,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Loan',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCustomerScreen(
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
                    enabled: true,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Return Cylinders',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCustomerScreen(
                                type: 'Return',
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
                    enabled: true,
                    titleFontSize: 25.0,
                    height: 15,
                    elevation: 2,
                  ),
                  OptionCard(
                    title: 'Leak',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCustomerScreen(
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
                    enabled: true,
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
                      final itemSummary =
                          await getItemSummary(routeCard.routeCardId);
                      final itemSummaryCW = await getItemSummaryCustomerWise(
                          routeCard.routeCardId);
                      final itemSummaryCWLeak =
                          await getItemSummaryCustomerWiseLeak(
                              routeCard.routeCardId);
                      final itemSummaryCWReturnC =
                          await getReturnCylinderSummaryCustomerWiseLeak(
                              routeCard.routeCardId);
                      pop(context);
                      final List<ItemSummaryCustomerWiseFull> li = [];
                      final List<ItemSummaryCustomerWiseFull> liLeak = [];
                      final List<ItemSummaryCustomerWiseFull> liRC = [];
                      itemSummaryCW.forEach((element1) {
                        itemSummaryCW.forEach((element2) {
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
                                    .contains(element1.item?.itemName))) {
                              li.add(ItemSummaryCustomerWiseFull(
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
                                          .invoice?.customer?.businessName!)! +
                                      (element1.item?.itemName!)!));
                            }
                          }
                        });
                        if (!(li.map((e) => e.unique).contains(
                            (element1.invoice?.customer?.businessName)! +
                                (element1.item?.itemName!)!))) {
                          li.add(ItemSummaryCustomerWiseFull(
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
                                  (element1.invoice?.customer?.businessName!)! +
                                      (element1.item?.itemName!)!));
                        }
                      });

                      itemSummaryCWLeak.forEach((element1) {
                        liLeak.add(ItemSummaryCustomerWiseFull(
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
                                (element1.invoice?.customer?.businessName!)! +
                                    (element1.item?.itemName!)!));
                      });
                      itemSummaryCWReturnC.forEach((element1) {
                        liRC.add(ItemSummaryCustomerWiseFull(
                            customerName:
                                element1.invoice?.customer?.businessName,
                            itemName: element1.item?.itemName,
                            recivedQty: int.parse(element1.selQty ?? '0'),
                            issuedQty: 0,
                            unique: ''));
                      });
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
                      await getItemsByRoutecard(
                              routeCardId: routeCard.routeCardId,
                              onlyRefill: false,
                              priceLevelId: 1,
                              type: data.currentRouteCard!.status == 0
                                  ? ''
                                  : 'rc-summary')
                          .then((rcItems) {
                        for (var element in rcItems) {
                          if (element.item?.itemTypeId != 5) {
                            data.addRCItem(element);
                          }
                        }
                      });
                      final rcItemSummary = await getItemsSummaryByRoutecard(
                          routeCardId: routeCard.routeCardId);
                      pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StockScreen(rcItemSummary: rcItemSummary)));
                    },
                    enabled: data.currentRouteCard!.status == 1,
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
