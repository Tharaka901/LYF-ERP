import 'package:flutter/material.dart';
import 'package:gsr/models/loan_stock.dart';
import 'package:gsr/models/rcItemSummary.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class StockScreen extends StatelessWidget {
  final List<RcItemsSummary> rcItemSummary;
  static const routeId = 'STOCK';
  const StockScreen({super.key, required this.rcItemSummary});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: ListView(
          children: [
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Date:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          dataProvider.currentRouteCard!.date!,
                          //date(dataProvider.currentRouteCard!.date as DateTime, format: 'dd.MM.yyyy'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Route:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          dataProvider.currentRouteCard?.route.routeName ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Route Card No:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          dataProvider.currentRouteCard?.routeCardNo ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'Issued Stock',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    children: [
                      titleCell(
                        'Item',
                        align: TextAlign.start,
                      ),
                      titleCell(
                        'Full',
                        align: TextAlign.start,
                      ),
                      titleCell('Empty'),
                      titleCell(
                        'Total',
                        align: TextAlign.end,
                      ),
                    ],
                  ),
                  ...dataProvider.rcItemList.map(
                    (item) {
                      double emptyCount = 0;
                      if (item.itemId == 2) {
                        dataProvider.rcItemList.forEach((item2) {
                          if (item2.itemId == 28) {
                            emptyCount = item2.transferQty;
                          }
                        });
                      }
                      if (item.itemId == 11) {
                        dataProvider.rcItemList.forEach((item2) {
                          if (item2.itemId == 26) {
                            emptyCount = item2.transferQty;
                          }
                        });
                      }
                      if (item.itemId == 12) {
                        dataProvider.rcItemList.forEach((item2) {
                          if (item2.itemId == 25) {
                            emptyCount = item2.transferQty;
                          }
                        });
                      }
                      if (item.itemId == 13) {
                        dataProvider.rcItemList.forEach((item2) {
                          if (item2.itemId == 27) {
                            emptyCount = item2.transferQty;
                          }
                        });
                      }
                      bool isNew = [14, 15, 16, 29].contains(item.itemId);
                      return TableRow(
                        children: [
                          cell(
                            item.item?.itemName ?? '',
                            align: TextAlign.start,
                          ),
                          cell(
                            item.transferQty.toInt().toString(),
                            align: TextAlign.start,
                          ),
                          cell(isNew ? '-' : emptyCount.toInt().toString()),
                          cell(
                            (item.transferQty + emptyCount).toInt().toString(),
                            align: TextAlign.end,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            const Text(
              'Received Stock',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    children: [
                      titleCell(
                        'Item',
                        align: TextAlign.start,
                      ),
                      titleCell(
                        'Full',
                        align: TextAlign.start,
                      ),
                      titleCell('Empty'),
                      titleCell('Deposit'),
                      titleCell(
                        'Total',
                        align: TextAlign.end,
                      ),
                    ],
                  ),
                  ...dataProvider.rcItemList.map(
                    (item) {
                      int fullCount = item.transferQty.toInt();
                      int depositeCount = 0;
                      int refill = 0;
                      int returnCSum = 0;
                      rcItemSummary.forEach((item2) => {
                            if (item.itemId == item2.id)
                              {
                                returnCSum = int.parse(
                                        item2.returnEmptyCount ?? '0') +
                                    int.parse(item2.returnRefillCount ?? '0'),
                                fullCount = (item.transferQty.toInt() -
                                        int.parse(item2.refill)) +
                                    int.parse(item2.returnRefillCount ?? '0'),
                                depositeCount = int.parse(item2.deposite),
                                refill = int.parse(item2.refill) +
                                    int.parse(item2.returnEmptyCount ?? '0'),
                              }
                          });
                      bool isNew = [14, 15, 16, 29].contains(item.itemId);
                      return TableRow(
                        children: [
                          cell(
                            item.item?.itemName ?? '',
                            align: TextAlign.start,
                          ),
                          cell(
                            fullCount.toString(),
                            align: TextAlign.start,
                          ),
                          cell(isNew
                              ? '-'
                              : (refill - depositeCount).toString()),
                          Padding(
                            padding: const EdgeInsets.only(right: 0, top: 5),
                            child: Text(
                              (isNew ? '-' : depositeCount).toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          cell(
                            (isNew
                                    ? fullCount
                                    : item.transferQty.toInt() + returnCSum)
                                .toString(),
                            align: TextAlign.end,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'Loan Stock',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder<List<LoanStock>>(
                future: getLoanStock(
                    dataProvider.currentRouteCard?.routeCardId ?? 0),
                builder: (context, snapData) {
                  if (snapData.hasData) {
                    if (snapData.data!.isEmpty) {
                      return const Center(
                        child: Text('No Loan Data'),
                      );
                    } else {
                      List<LoanStockSummery> fullList = [];

                      snapData.data!.forEach((item1) {
                        snapData.data!.forEach((item2) {
                          if (item1.item?.itemName == item2.item?.itemName &&
                              item1.invoice?.status != item2.invoice?.status) {
                            if (!(fullList
                                .map((e) => e.itemName)
                                .contains(item1.item?.itemName))) {
                              fullList.add(LoanStockSummery(
                                itemName: item1.item?.itemName,
                                recivedStock: item1.invoice?.status == 2
                                    ? item1.selQty
                                    : item2.selQty,
                                issuedStock: item1.invoice?.status == 3
                                    ? item1.selQty
                                    : item2.selQty,
                              ));
                            }
                          }
                        });
                      });

                      snapData.data!.forEach((item1) {
                        if (!(fullList
                            .map((e) => e.itemName)
                            .contains(item1.item?.itemName))) {
                          fullList.add(LoanStockSummery(
                            itemName: item1.item?.itemName,
                            recivedStock:
                                item1.invoice?.status == 2 ? item1.selQty : '0',
                            issuedStock:
                                item1.invoice?.status == 3 ? item1.selQty : '0',
                          ));
                          // }
                        }
                      });

                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Table(
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  children: [
                                    titleCell(
                                      'Item',
                                      align: TextAlign.start,
                                    ),
                                    titleCell(
                                      'Issued',
                                      align: TextAlign.start,
                                    ),
                                    titleCell('Recived'),
                                    titleCell(
                                      'Total',
                                      align: TextAlign.end,
                                    ),
                                  ],
                                ),
                                ...fullList.map(
                                  (stock) {
                                    return TableRow(
                                      children: [
                                        cell(
                                          stock.itemName ?? '',
                                          align: TextAlign.start,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30, top: 5),
                                          child: Text(
                                            stock.issuedStock ?? '0',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 0, top: 5),
                                          child: Text(
                                            stock.recivedStock ?? '0',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        cell(
                                          (int.parse(stock.recivedStock ??
                                                      '0') -
                                                  int.parse(
                                                      stock.issuedStock ?? '0'))
                                              .toString(),
                                          align: TextAlign.end,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  } else {
                    if (snapData.hasError) {
                      return Center(
                        child: Text(snapData.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                }),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'Leak Stock',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder<List<LoanStock>>(
                future: getLeakStock(
                    dataProvider.currentRouteCard?.routeCardId ?? 0),
                builder: (context, snapData) {
                  if (snapData.hasData) {
                    if (snapData.data!.isEmpty) {
                      return const Center(
                        child: Text('No Loan Data'),
                      );
                    } else {
                      List<LoanStockSummery> fullList = [];

                      snapData.data!.forEach((item1) {
                        snapData.data!.forEach((item2) {
                          if (item1.item?.itemName == item2.item?.itemName &&
                              item1.invoice?.status != item2.invoice?.status) {
                            if (!(fullList
                                .map((e) => e.itemName)
                                .contains(item1.item?.itemName))) {
                              fullList.add(LoanStockSummery(
                                itemName: item1.item?.itemName,
                                recivedStock: item1.invoice?.status == 2 &&
                                        item1.item?.itemTypeId != 7
                                    ? item1.selQty
                                    : '0',
                                issuedStock: item1.status == 6 &&
                                        item1.item?.itemTypeId == 7
                                    ? item1.selQty
                                    : '0',
                              ));
                            }
                          }
                        });
                      });

                      snapData.data!.forEach((item1) {
                        if (!(fullList
                            .map((e) => e.itemName)
                            .contains(item1.item?.itemName))) {
                          fullList.add(LoanStockSummery(
                            itemName: item1.item?.itemName,
                            recivedStock: item1.invoice?.status == 2 &&
                                    item1.item?.itemTypeId != 7
                                ? item1.selQty
                                : '0',
                            issuedStock:
                                item1.status == 6 && item1.item?.itemTypeId == 7
                                    ? item1.selQty
                                    : '0',
                          ));
                          // }
                        }
                      });

                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Table(
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  children: [
                                    titleCell(
                                      'Item',
                                      align: TextAlign.start,
                                    ),
                                    titleCell(
                                      'Issued',
                                      align: TextAlign.start,
                                    ),
                                    titleCell('Recived'),
                                    titleCell(
                                      'Total',
                                      align: TextAlign.end,
                                    ),
                                  ],
                                ),
                                ...fullList.map(
                                  (stock) {
                                    return TableRow(
                                      children: [
                                        cell(
                                          stock.itemName ?? '',
                                          align: TextAlign.start,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30, top: 5),
                                          child: Text(
                                            stock.issuedStock ?? '0',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 0, top: 5),
                                          child: Text(
                                            stock.recivedStock ?? '0',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        cell(
                                          (int.parse(stock.recivedStock ??
                                                      '0') +
                                                  int.parse(
                                                      stock.issuedStock ?? '0'))
                                              .toString(),
                                          align: TextAlign.end,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  } else {
                    if (snapData.hasError) {
                      return Center(
                        child: Text(snapData.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                })
          ],
        ),
      ),
    );
  }

  TableCell cell(String value, {TextAlign? align}) => TableCell(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            value,
            textAlign: align ?? TextAlign.center,
          ),
        ),
      );
  TableCell titleCell(String value, {TextAlign? align}) => TableCell(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            value,
            textAlign: align ?? TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
  Widget text(String value) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
