import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stock_view_model.dart';
import '../../../commons/common_methods.dart';

class ReturnCylinderStockSection extends StatelessWidget {
  const ReturnCylinderStockSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
      builder: (context, stockViewModelData, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            const Text(
              'Return Cylinder Stock',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(height: 10.0),
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
                      titleCell('Item', align: TextAlign.start),
                      titleCell('Quantity', align: TextAlign.end),
                    ],
                  ),
                  ...stockViewModelData.returnCylinderSummaryCustomerWiseLeak
                      .map(
                    (item) => TableRow(
                      children: [
                        cell(item.item?.itemName ?? '', align: TextAlign.start),
                        cell(item.selQty.toString(), align: TextAlign.end),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
