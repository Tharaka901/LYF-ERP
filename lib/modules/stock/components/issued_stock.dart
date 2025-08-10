import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:provider/provider.dart';

import '../../../providers/data_provider.dart';
import '../stock_view_model.dart';

class IssuedStock extends StatelessWidget {
  const IssuedStock({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Consumer<StockViewModel>(
        builder: (context, stockViewModelData, child) {
      return Column(
        children: [
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
                ...stockViewModelData.routeCardItems.map(
                  (item) {
                    double emptyCount = 0;
                    if (item.itemId == 2) {
                      for (var item2 in dataProvider.rcItemList) {
                        if (item2.itemId == 28) {
                          emptyCount = item2.transferQty;
                        }
                      }
                    }
                    if (item.itemId == 11) {
                      for (var item2 in dataProvider.rcItemList) {
                        if (item2.itemId == 26) {
                          emptyCount = item2.transferQty;
                        }
                      }
                    }
                    if (item.itemId == 12) {
                      for (var item2 in dataProvider.rcItemList) {
                        if (item2.itemId == 25) {
                          emptyCount = item2.transferQty;
                        }
                      }
                    }
                    if (item.itemId == 13) {
                      for (var item2 in dataProvider.rcItemList) {
                        if (item2.itemId == 27) {
                          emptyCount = item2.transferQty;
                        }
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
          )
        ],
      );
    });
  }
}
