import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/return_cylinder/select_credit_invoice_for_return_cylinder.dart';
import 'package:provider/provider.dart';

import '../invoice/invoice_provider.dart';
import '../../widgets/text/column_text.dart';
import '../../widgets/text/row_text.dart';
import '../../widgets/tiles/basic_tile.dart';

class ReturnNoteScreen extends StatefulWidget {
  final String type;
  const ReturnNoteScreen({super.key, required this.type});

  @override
  State<ReturnNoteScreen> createState() => _ReturnNoteScreenState();
}

class _ReturnNoteScreenState extends State<ReturnNoteScreen> {
  DataProvider? dataProvider;
  InvoiceProvider? invoiceProvider;

  @override
  void initState() {
    super.initState();
    invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    invoiceProvider!.getReturnCylinderInvoiceNumber(
        dataProvider!.currentRouteCard!, context);
  }

  @override
  Widget build(BuildContext context) {
    const titleRowColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Note'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  const SelectCreditInvoiceForReturnCylinderScreen()));
        },
        child: const Text('Next'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Return Note',
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ColumnText(
                title: 'Return From:',
                content: dataProvider!.selectedCustomer!.businessName ?? '',
              ),
              const SizedBox(height: 10),
              RowText(
                label: 'Date: ',
                value: date(DateTime.now(), format: 'dd.MM.yyyy'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Return Note Num:',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  Consumer<InvoiceProvider>(
                    builder: (context, invoiceProvider, _) =>
                        invoiceProvider.returnCylinderInvoiceNu != null
                            ? Text(
                                'GRN/${invoiceProvider.returnCylinderInvoiceNu}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              )
                            : const Text(
                                'Generating...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Consumer<DataProvider>(
                  builder: (context, data, _) => Table(
                    border: const TableBorder.symmetric(),
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
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Unit Price',
                              textAlign: TextAlign.center,
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
                              'Total',
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
                      ...data.itemList.map(
                        (item) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                (data.itemList.indexOf(item) + 1).toString(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                item.item.itemName,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                num(item.quantity),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                num(item.item.salePrice),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                num(item.quantity * item.item.salePrice),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              BasicTile(
                  label: 'Sub Total',
                  value: formatPrice(dataProvider!.getTotalAmount())),
              BasicTile(
                  label: 'VAT 18%', value: formatPrice(dataProvider!.vat)),
              BasicTile(
                  label: 'Grand Total',
                  value: formatPrice(dataProvider!.grandTotal)),
              const Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
