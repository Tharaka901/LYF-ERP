import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/components/text_containers.dart';
import 'package:gsr/modules/return_cylinder/providers/return_cylinder_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/return_cylinder/screens/select_credit_invoice_for_return_cylinder.dart';
import 'package:provider/provider.dart';

class ReturnNoteScreen extends StatefulWidget {
  final String type;
  const ReturnNoteScreen({super.key, required this.type});

  @override
  State<ReturnNoteScreen> createState() => _ReturnNoteScreenState();
}

class _ReturnNoteScreenState extends State<ReturnNoteScreen> {
  @override
  void initState() {
    super.initState();
    final returnCylinderProvider =
        Provider.of<ReturnCylinderProvider>(context, listen: false);
    returnCylinderProvider.getReturnCylinderInvoiceNumber(context);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final vat = dataProvider.selectedCustomer?.vat?.vatAmount ?? "18";
    final returnCylinderProvider =
        Provider.of<ReturnCylinderProvider>(context);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Return Note',
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Return From:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            dataProvider.selectedCustomer!.businessName ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Date: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      dataProvider.currentRouteCard!.date?.toString().split(' ')[0] ?? 'No Date',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Return Note Num:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        'GRN/${returnCylinderProvider.returnCylinderInvoiceNumber}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.clip),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Consumer<ReturnCylinderProvider>(
                  builder: (context, returnCylinderProvider, _) => Table(
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
                      ...returnCylinderProvider.selectedItems.map(
                        (item) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                (returnCylinderProvider.selectedItems
                                            .indexOf(item) +
                                        1)
                                    .toString(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                item.itemName,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                item.itemQty.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                num(item.salePrice),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                num(item.itemQty! * item.salePrice),
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
              Row(
                children: [
                  const TextContainer(text: 'Total'),
                  const Spacer(),
                  TextContainer(
                      text:
                          formatPrice(returnCylinderProvider.totalItemAmount)),
                ],
              ),
              Row(
                children: [
                  const TextContainer(text: 'Non VAT Item Total'),
                  const Spacer(),
                  TextContainer(
                      text: formatPrice(returnCylinderProvider.nonVatAmount)),
                ],
              ),
              Row(
                children: [
                  TextContainer(text: 'VAT $vat%'),
                  const Spacer(),
                  TextContainer(
                      text: formatPrice(returnCylinderProvider.vatAmount)),
                ],
              ),
              Row(
                children: [
                  const TextContainer(text: 'Total Return Cylinder Price'),
                  const Spacer(),
                  TextContainer(
                      text: formatPrice(returnCylinderProvider.grandPrice)),
                ],
              ),
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
