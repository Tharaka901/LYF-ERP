import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../commons/common_methods.dart';
import '../stock_view_model.dart';

class LoanStockSection extends StatelessWidget {
  const LoanStockSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
        builder: (context, stockViewModelData, child) {
      return Column(
        children: [
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
                    ...stockViewModelData.routeCardSoldLoanItems.map(
                      (stock) {
                        return TableRow(
                          children: [
                            cell(
                              stock.item.itemName,
                              align: TextAlign.start,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30, top: 5),
                              child: Text(
                                stock.receivedStock.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                stock.issuedStock.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            cell(
                              (stock.issuedStock - stock.receivedStock)
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
