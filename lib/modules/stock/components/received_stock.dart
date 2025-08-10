import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:provider/provider.dart';

import '../stock_view_model.dart';

class ReceivedStock extends StatelessWidget {
  const ReceivedStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
        builder: (context, stockViewModelData, child) {
      return Column(
        children: [
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
                    titleCell('Leak'),
                    titleCell(
                      'Total',
                      align: TextAlign.end,
                    ),
                  ],
                ),
                ...stockViewModelData.routeCardItems.map((item) {
                  int fullCount = item.transferQty.toInt();
                  int depositeCount = 0;
                  int refill = 0;
                  int returnCSum = 0;
                  int leak = 0;
                  int damage = 0;
                  int free = 0;
                  int freeEmpty = 0;
                  int loanIssued = 0;
                  int loanReceived = 0;
                  int returnCylinderFull = 0;
                  int returnCylinderEmpty = 0;
                  for (var item2 in stockViewModelData.routeCardSoldItems) {
                    if (item.itemId == item2.id) {
                      fullCount = (item.transferQty.toInt() +
                              (item2.returnCylinderFull ?? 0) -
                              item2.refill) +
                          (item2.returnRefillCount ?? 0);
                      depositeCount = item2.deposite;
                      refill = item2.refill +
                          (item2.returnCylinderEmpty ?? 0) +
                          (item2.returnEmptyCount ?? 0);
                      leak = item2.leak;
                      damage = item2.damage;
                      free = item2.free;
                      freeEmpty = item2.freeEmpty;
                      loanIssued = item2.loanIssued;
                      loanReceived = item2.loanReceived;
                      returnCylinderFull = item2.returnCylinderFull ?? 0;
                      returnCylinderEmpty = item2.returnCylinderEmpty ?? 0;
                    }
                  }

                  bool isNew = [14, 15, 16, 29].contains(item.itemId);
                  return TableRow(
                    children: [
                      cell(
                        item.item?.itemName ?? '',
                        align: TextAlign.start,
                      ),
                      cell(
                        (fullCount - free).toString(),
                        align: TextAlign.start,
                      ),
                      cell(isNew
                          ? '-'
                          : (refill -
                                  depositeCount +
                                  damage -
                                  freeEmpty -
                                  loanIssued +
                                  loanReceived -
                                  returnCylinderFull) // + return empty
                              .toString()),
                      Padding(
                        padding: const EdgeInsets.only(right: 0, top: 5),
                        child: Text(
                          (isNew ? '-' : depositeCount).toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      cell(leak.toString()),
                      cell(
                        (isNew
                                ? fullCount
                                : item.transferQty.toInt() +
                                    returnCSum +
                                    leak -
                                    depositeCount +
                                    damage -
                                    loanIssued +
                                    loanReceived +
                                    returnCylinderEmpty)
                            .toString(),
                        align: TextAlign.end,
                      ),
                    ],
                  );
                }),
              ],
            ),
          )
        ],
      );
    });
  }
}
