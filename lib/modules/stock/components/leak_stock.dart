import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../commons/common_methods.dart';
import '../../../models/loan_stock/loan_stock.dart';
import '../stock_view_model.dart';

class LeakStockSection extends StatelessWidget {
  const LeakStockSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
        builder: (context, stockViewModelData, child) {
      List<LoanStockSummery> fullList = [];

      for (var item1 in stockViewModelData.routeCardSoldLeakItems) {
        for (var item2 in stockViewModelData.routeCardSoldLeakItems) {
          if (item1.item!.itemName == item2.item!.itemName &&
              item1.invoice!.status != item2.invoice!.status) {
            if (!(fullList
                .map((e) => e.itemName)
                .contains(item1.item?.itemName))) {
              fullList.add(LoanStockSummery(
                itemName: item1.item?.itemName,
                recivedStock:
                    item1.invoice?.status == 2 && item1.item?.itemTypeId != 7
                        ? item1.selQty
                        : '0',
                issuedStock: item1.status == 6 && item1.item?.itemTypeId == 7
                    ? item1.selQty
                    : '0',
              ));
            }
          }
        }
      }

      for (var item1 in stockViewModelData.routeCardSoldLeakItems) {
        if (!(fullList.map((e) => e.itemName).contains(item1.item?.itemName))) {
          fullList.add(LoanStockSummery(
            itemName: item1.item?.itemName,
            recivedStock:
                item1.invoice?.status == 2 && item1.item?.itemTypeId != 7
                    ? item1.selQty
                    : '0',
            issuedStock: item1.status == 6 && item1.item?.itemTypeId == 7
                ? item1.selQty
                : '0',
          ));
          // }
        }
      }
      return Column(
        children: [
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
          Column(
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
                              padding: const EdgeInsets.only(right: 30, top: 5),
                              child: Text(
                                stock.issuedStock ?? '0',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                stock.recivedStock ?? '0',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            cell(
                              (int.parse(stock.recivedStock ?? '0') +
                                      int.parse(stock.issuedStock ?? '0'))
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
          )
        ],
      );
    });
  }
}
