import 'package:flutter/material.dart';
import 'package:gsr/models/item_summary.dart';
import 'package:gsr/models/item_summary_customer_wise.dart';
import 'package:gsr/screens/select_previous_invoice_screen.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';

class RCSummaryScreen extends StatefulWidget {
  static const routeId = 'SUMMARY';
  final List<ItemSummary> itemSummary;
  final List<ItemSummaryCustomerWiseFull> itemSummaryCW;
  final List<ItemSummaryCustomerWiseFull> itemSummaryCWLeak;
  final List<ItemSummaryCustomerWiseFull> itemSummaryCWReturnC;
  const RCSummaryScreen(
      {Key? key,
      required this.itemSummary,
      required this.itemSummaryCW,
      required this.itemSummaryCWLeak,
      required this.itemSummaryCWReturnC})
      : super(key: key);

  @override
  State<RCSummaryScreen> createState() => _RCSummaryScreenState();
}

class _RCSummaryScreenState extends State<RCSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    const titleRowColor = Colors.white;
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue,
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   child: const Icon(
      //     Icons.done,
      //   ),
      // ),
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
              'Sales',
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '#',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Item',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...widget.itemSummary.map(
                    (item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              (widget.itemSummary.indexOf(item) + 1).toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              item.item?.itemName ?? '',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              item.selQty ?? '0',
                              textAlign: TextAlign.center,
                            ),
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
              'Loan Summery',
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '#',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Item',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Issued Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Recived Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(5.0),
                      //   child: Text(
                      //     'Total',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: titleRowColor,
                      //       fontSize: 11.0,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  ...widget.itemSummaryCW.map(
                    (item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              (widget.itemSummaryCW.indexOf(item) + 1)
                                  .toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          cell(
                            item.customerName ?? '',
                            align: TextAlign.start,
                          ),
                          cell(
                            item.itemName ?? '',
                            align: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              item.issuedQty.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              item.recivedQty.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(5.0),
                          //   child: Text(
                          //     (item.recivedQty! - item.issuedQty!).toString(),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            const Text(
              'Leak Summery',
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '#',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Item',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Issued Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Recived Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...widget.itemSummaryCWLeak.map(
                    (item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              (widget.itemSummaryCWLeak.indexOf(item) + 1)
                                  .toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          cell(
                            item.customerName ?? '',
                            align: TextAlign.start,
                          ),
                          cell(
                            item.itemName ?? '',
                            align: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              item.issuedQty.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              item.recivedQty.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'Return Summery',
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '#',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Item',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Return Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleRowColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...widget.itemSummaryCWReturnC.map(
                    (item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              (widget.itemSummaryCWLeak.indexOf(item) + 1)
                                  .toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          cell(
                            item.customerName ?? '',
                            align: TextAlign.start,
                          ),
                          cell(
                            item.itemName ?? '',
                            align: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              item.recivedQty.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
