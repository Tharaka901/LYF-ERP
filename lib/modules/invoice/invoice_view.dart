import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/invoice/invoice_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/add_payment_screen.dart';
import 'package:gsr/widgets/tiles/basic_tile.dart';
import 'package:provider/provider.dart';

import '../../commons/common_consts.dart';

class ViewInvoiceScreen extends StatefulWidget {
  static const routeId = 'INVOICE';
  final bool? isManual;
  const ViewInvoiceScreen({Key? key, this.isManual}) : super(key: key);

  @override
  State<ViewInvoiceScreen> createState() => _ViewInvoiceScreenState();
}

class _ViewInvoiceScreenState extends State<ViewInvoiceScreen> {
  final TextEditingController invoiceNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    if (invoiceProvider.invoiceNu == null)
      invoiceProvider.getInvoiceNu(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    const titleRowColor = Colors.white;
    final isManual = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['isManual'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      floatingActionButton: Consumer<InvoiceProvider>(
        builder: ((context, ip, child) => ip.invoiceNu == null
            ? CircularProgressIndicator()
            : FloatingActionButton(
                onPressed: () async {
                  if (isManual ?? false) {
                    if (formKey.currentState!.validate()) {
                      waiting(context, body: 'Sending...');
                      await invoiceProvider.createInvoiceDB(
                          context, invoiceNoController.text.trim());
                      pop(context);
                      Navigator.pushNamed(context, AddPaymentScreen.routeId,
                          arguments: {
                            'invoiceRes': invoiceProvider.invoiceRes,
                            'isManual': isManual
                          });
                    }
                  } else {
                    waiting(context, body: 'Sending...');
                    await invoiceProvider.createInvoiceDB(context, null);
                    pop(context);
                    print(invoiceProvider.invoiceRes);
                    Navigator.pushNamed(context, AddPaymentScreen.routeId,
                        arguments: {'invoiceRes': invoiceProvider.invoiceRes});
                  }
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 40,
                ),
              )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Invoice',
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
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
                              'Bill to:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              dataProvider.selectedCustomer?.businessName ?? '',
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
                              'Address to:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              dataProvider.selectedCustomer?.address ?? '-',
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
                              'Customer VAT ID:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              dataProvider.selectedCustomer!.customerVat ?? '-',
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
                          fontSize: 20.0,
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
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Invoice number:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Consumer<InvoiceProvider>(
                        builder: (context, ip, _) {
                          return ip.invoiceNu != null
                              ? Text(ip.invoiceNu!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.clip)
                              : const Text(
                                  'Generating...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<DataProvider>(
                    builder: (context, data, _) => Table(
                      border: TableBorder.symmetric(),
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
                                'Unit price',
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
                                'Amount',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: titleRowColor,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...data.itemList
                            .map(
                              (item) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      (data.itemList.indexOf(item) + 1)
                                          .toString(),
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
                                      formatPrice(item.item.hasSpecialPrice !=
                                              null
                                          ? item.item.hasSpecialPrice!.itemPrice
                                          : item.item.salePrice),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      formatPrice(
                                          (item.item.hasSpecialPrice != null
                                                  ? item.item.hasSpecialPrice!
                                                      .itemPrice
                                                  : item.item.salePrice) *
                                              item.quantity),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),

                //! Invoice total summery
                BasicTile(
                    label: 'Sub Total',
                    value: formatPrice(dataProvider.getTotalAmount())),
                BasicTile(
                    label: 'VAT 18%', value: formatPrice(dataProvider.vat)),
                if (dataProvider.nonVatItemTotal > 0)
                  BasicTile(
                      label: 'Non VAT Item Total',
                      value: dataProvider.nonVatItemTotal.toString()),

                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: width * 0.6 - 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.blue,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'Grand Total:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    formatPrice(dataProvider.grandTotal),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (isManual ?? false)
                  TextFormField(
                    controller: invoiceNoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Invoice Number',
                    ),
                    style: defaultTextFieldStyle,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Invoice Number cannot be empty!';
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
