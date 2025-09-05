import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/invoice.dart';
import 'package:gsr/models/invoice_item.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

import '../../widgets/buttons/custom_outline_button.dart';
import 'leak_invoice_view_model.dart';

class LeakNoteScreen extends StatefulWidget {
  final String type;
  const LeakNoteScreen({super.key, required this.type});

  @override
  State<LeakNoteScreen> createState() => _LeakNoteScreenState();
}

class _LeakNoteScreenState extends State<LeakNoteScreen> {
  late LeakInvoiceViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = LeakInvoiceViewModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    const titleRowColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text(dataProvider.itemList[0].leakType == 2
            ? 'Leak Recived Note'
            : 'Leak Issued Note'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dataProvider.itemList[0].leakType == 2
                    ? 'Leak Recived Note'
                    : 'Leak Issued Note',
                style: const TextStyle(
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
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            dataProvider.itemList[0].leakType == 2
                                ? 'Recived To:'
                                : 'Issued To:',
                            style: const TextStyle(
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
                      date(DateTime.now(), format: 'dd.MM.yyyy'),
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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      dataProvider.itemList[0].leakType == 2
                          ? 'Recived Note Num:'
                          : 'Issued Note Num:',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FutureBuilder<String>(
                      future: leakInvoiceNumber(context),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          dataProvider.setCurrentInvoice(Invoice(
                            invoiceItems: dataProvider.itemList
                                .map(
                                  (addedItem) => InvoiceItem(
                                    item: addedItem.item,
                                    itemPrice:
                                        addedItem.item.hasSpecialPrice != null
                                            ? addedItem
                                                .item.hasSpecialPrice!.itemPrice
                                            : addedItem.item.salePrice,
                                    itemQty: addedItem.quantity,
                                    status: 1,
                                  ),
                                )
                                .toList(),
                            invoiceNo: snapshot.data!,
                            routecardId:
                                dataProvider.currentRouteCard!.routeCardId,
                            amount: dataProvider.getTotalAmount(),
                            customerId:
                                dataProvider.selectedCustomer?.customerId ?? 0,
                            employeeId:
                                dataProvider.currentEmployee!.employeeId!,
                          ));
                          return Text(
                              (dataProvider.itemList[0].leakType == 2
                                      ? 'LE/R'
                                      : 'LE/I') +
                                  snapshot.data!.replaceAll('RCN', ''),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.clip);
                        } else {
                          return const Text(
                            'Generating...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (dataProvider.itemList[0].leakType == 2)
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
                                'Cylinder No',
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
                                'Reference',
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
                                  item.cylinderNo ?? '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  item.referenceNo ?? '',
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
              if (dataProvider.itemList[0].leakType != 2)
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
                                'cylinder No',
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
                                  item.cylinderNo.toString(),
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
              const SizedBox(height: 10),
              CustomOutlineButton(
                text: 'Save',
                onPressed: viewModel.onPressedSaveButton,
                color: Colors.blue[800],
              ),
              const SizedBox(height: 10),
              CustomOutlineButton(
                text: 'Print',
                onPressed: viewModel.onPressedPrintButton,
                color: Colors.blue[800],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
