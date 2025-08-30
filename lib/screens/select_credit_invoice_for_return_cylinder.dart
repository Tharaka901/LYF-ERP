import 'package:flutter/material.dart';
import 'package:gsr/screens/route_card_screen.dart';
import 'package:gsr/modules/select_customer/select_customer_view.dart';
import 'package:provider/provider.dart';
import '../commons/common_methods.dart';
import '../models/invoice/invoice_model.dart';
import '../models/issued_invoice_paid_model/issued_invoice_paid.dart';
import '../providers/data_provider.dart';
import '../services/database.dart';
import '../widgets/previous_invoice_form.dart';

class SelectCreditInvoiceForReturnCylinderScreen extends StatefulWidget {
  const SelectCreditInvoiceForReturnCylinderScreen({Key? key});

  @override
  State<SelectCreditInvoiceForReturnCylinderScreen> createState() =>
      _SelectCreditInvoiceForReturnCylinderScreenState();
}

class _SelectCreditInvoiceForReturnCylinderScreenState
    extends State<SelectCreditInvoiceForReturnCylinderScreen> {
  final invoiceFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Invoice'),
      ),
      resizeToAvoidBottomInset: false,
      body: selectedCustomer != null
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Return Cylinder Price',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                          price(dataProvider.itemList
                              .map((e) => e.item.salePrice * e.quantity)
                              .reduce((value, element) => value + element)),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<InvoiceModel>>(
                    future: creditInvoices(context,
                        cId: selectedCustomer.customerId, type: 'with-cheque'),
                    builder:
                        (context, AsyncSnapshot<List<InvoiceModel>> snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: Form(
                                key: invoiceFormKey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:
                                          DropdownButtonFormField<InvoiceModel>(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          labelText: snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? 'Loading...'
                                              : (snapshot.hasData &&
                                                      snapshot.data!.isNotEmpty
                                                  ? 'Select invoice'
                                                  : 'No previous invoices'),
                                        ),
                                        validator: (value) {
                                          if (dataProvider.selectedInvoice ==
                                              null) {
                                            return 'Select an invoice!';
                                          } else if (dataProvider
                                              .issuedInvoicePaidList
                                              .where((element) =>
                                                  element.issuedInvoice
                                                      .invoiceId ==
                                                  dataProvider.selectedInvoice!
                                                      .invoiceId)
                                              .isNotEmpty) {
                                            return 'Already added!';
                                          }
                                          return null;
                                        },
                                        items: snapshot.hasData
                                            ? snapshot.data!.map((element) {
                                                return DropdownMenuItem(
                                                  value: element,
                                                  child: Text(
                                                    '${element.invoiceNo}  ${price(element.creditValue!)}',
                                                  ),
                                                );
                                              }).toList()
                                            : [],
                                        onChanged: (invoice) {
                                          dataProvider
                                              .setSelectedInvoice(invoice);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Consumer<DataProvider>(
                                        builder: (context, data, _) =>
                                            IconButton(
                                          onPressed: () {
                                            if (invoiceFormKey.currentState!
                                                .validate()) {
                                              final amountController =
                                                  TextEditingController(
                                                      text: num(data
                                                          .selectedInvoice!
                                                          .creditValue!));
                                              final formKey =
                                                  GlobalKey<FormState>();

                                              confirm(
                                                context,
                                                title: data
                                                    .selectedInvoice!.invoiceNo,
                                                body: PreviousInvoiceForm(
                                                  issuedInvoice:
                                                      data.selectedInvoice!,
                                                  amountController:
                                                      amountController,
                                                  formKey: formKey,
                                                ),
                                                confirmText: 'Add',
                                                onConfirm: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    data.addPaidIssuedInvoice(
                                                      IssuedInvoicePaidModel(
                                                        chequeId: dataProvider
                                                            .selectedInvoice!
                                                            .chequeId,
                                                        creditAmount: data
                                                            .selectedInvoice!
                                                            .creditValue,
                                                        issuedInvoice: data
                                                            .selectedInvoice!,
                                                        paymentAmount: doub(
                                                            amountController
                                                                .text
                                                                .replaceAll(
                                                                    ',', '')),
                                                      ),
                                                    );
                                                    data.setSelectedInvoice(
                                                        null);
                                                    pop(context);
                                                    return;
                                                  }
                                                },
                                              );
                                              return;
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            size: 40,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                  SizedBox(height: 15),
                  Consumer<DataProvider>(
                      builder: (context, data, _) => data
                              .issuedInvoicePaidList.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Table(
                                    defaultColumnWidth:
                                        const IntrinsicColumnWidth(),
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        children: [
                                          titleCell(
                                            '#',
                                            align: TextAlign.start,
                                          ),
                                          titleCell(
                                            'Date',
                                            align: TextAlign.center,
                                          ),
                                          titleCell(
                                            'Invoice No:',
                                            align: TextAlign.center,
                                          ),
                                          titleCell(
                                            'Payment',
                                            align: TextAlign.center,
                                          ),
                                          titleCell(
                                            'X',
                                            align: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      ...data.issuedInvoicePaidList.map(
                                        (invoice) => TableRow(
                                          children: [
                                            cell(
                                              (data.issuedInvoicePaidList
                                                          .indexOf(invoice) +
                                                      1)
                                                  .toString(),
                                              align: TextAlign.start,
                                            ),
                                            cell(
                                              invoice.issuedInvoice.createdAt!,
                                              align: TextAlign.center,
                                            ),
                                            cell(invoice
                                                .issuedInvoice.invoiceNo),
                                            cell(
                                              price(invoice.paymentAmount)
                                                  .replaceAll('Rs.', ''),
                                              align: TextAlign.center,
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  data.removePaidIssuedInvoice(
                                                      invoice),
                                              child: const Icon(
                                                Icons.clear_rounded,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  children: [
                                    text('Total Payment'),
                                    const Spacer(),
                                    text(price(
                                        data.getTotalInvoicePaymentAmount())),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                SizedBox(height: 10),
                              ],
                            )
                          : dummy),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: OutlinedButton(
                      onPressed: () async {
                        final sum = dataProvider.itemList
                            .map((e) => e.item.salePrice * e.quantity)
                            .reduce((value, element) => value + element);
                        if (dataProvider.itemList
                                .map((e) => e.item.salePrice * e.quantity)
                                .reduce((value, element) => value + element) >=
                            dataProvider.getTotalInvoicePaymentAmount()) {
                          try {
                            waiting(context, body: 'Sending...');
                            final invoiceRes =
                                await createReturnCylinderInvoice(context);

                            for (var invoice
                                in dataProvider.issuedInvoicePaidList) {
                              if (invoice.creditAmount! <=
                                      invoice.paymentAmount &&
                                  invoice.chequeId == null) {
                                await respo('invoice/update',
                                    method: Method.put,
                                    data: {
                                      "invoiceId":
                                          invoice.issuedInvoice.invoiceId,
                                      "status": 2,
                                      "creditValue": 0
                                    });
                              } else {
                                await respo('invoice/update',
                                    method: Method.put,
                                    data: {
                                      "invoiceId":
                                          invoice.issuedInvoice.invoiceId,
                                      "status": 1,
                                      "creditValue": invoice.creditAmount! -
                                          invoice.paymentAmount
                                    });
                              }
                              if (invoice.chequeId != null) {
                                if (invoice.creditAmount! <=
                                    invoice.paymentAmount) {
                                  await respo('cheque/update',
                                      method: Method.put,
                                      data: {
                                        "id": invoice.chequeId,
                                        "isActive": 2,
                                        "balance": 0
                                      });
                                } else {
                                  await respo('cheque/update',
                                      method: Method.put,
                                      data: {
                                        "id": invoice.chequeId,
                                        "balance": invoice.creditAmount! -
                                            invoice.paymentAmount
                                      });
                                }
                              }
                              final data = {
                                "value": invoice.paymentAmount,
                                "paymentInvoiceId": invoiceRes.data["invoice"]
                                    ["id"],
                                "routecardId":
                                    dataProvider.currentRouteCard!.routeCardId,
                                "creditInvoiceId": invoice.chequeId != null
                                    ? invoice.chequeId
                                    : invoice.issuedInvoice.invoiceId,
                                "receiptNo": invoiceRes.data["invoice"]
                                    ["invoiceNo"],
                                "status": 4, //invoice.chequeId != null ? 3 : 2,
                                "type": "return-cheque"
                              };
                              await respo('credit-payment/create',
                                  method: Method.post, data: data);
                            }
                            if (dataProvider.itemList
                                    .map((e) => e.item.salePrice * e.quantity)
                                    .reduce(
                                        (value, element) => value + element) >
                                dataProvider.getTotalInvoicePaymentAmount()) {
                              await respo(
                                'customers/update',
                                method: Method.put,
                                data: {
                                  "customerId": selectedCustomer.customerId,
                                  "depositBalance": selectedCustomer
                                          .depositBalance +
                                      (dataProvider.itemList
                                              .map((e) =>
                                                  e.item.salePrice * e.quantity)
                                              .reduce((value, element) =>
                                                  value + element) -
                                          dataProvider
                                              .getTotalInvoicePaymentAmount()),
                                },
                              );
                              await respo(
                                'over-payment/create',
                                method: Method.post,
                                data: {
                                  "value": (dataProvider.itemList
                                              .map((e) =>
                                                  e.item.salePrice * e.quantity)
                                              .reduce((value, element) =>
                                                  value + element) -
                                          dataProvider
                                              .getTotalInvoicePaymentAmount())
                                      .toStringAsFixed(2),
                                  "status": 2,
                                  "paymentInvoiceId": invoiceRes.data["invoice"]
                                      ["id"],
                                  "routecardId": dataProvider
                                      .currentRouteCard!.routeCardId,
                                  "receiptNo": invoiceRes.data["invoice"]
                                      ["invoiceNo"],
                                  "customerId": selectedCustomer.customerId
                                },
                              );
                            }
                            dataProvider.itemList.clear();
                            dataProvider.issuedInvoicePaidList.clear();
                            pop(context);
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteCardScreen.routeId, (route) => false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectCustomerView(
                                        type: 'Return',
                                      )),
                            ).then((value) {
                              dataProvider.clearItemList();
                              dataProvider.clearChequeList();
                              dataProvider.clearRCItems();
                              dataProvider.clearPaidBalanceList();
                              dataProvider.setSelectedCustomer(null);
                              dataProvider.setSelectedVoucher(null);
                              dataProvider.setCurrentInvoice(null);
                            });
                            toast('Success', toastState: TS.success);
                          } catch (e) {
                            toast(e.toString(), toastState: TS.error);
                          }
                        } else {
                          toast('Please set total payment ${sum}',
                              toastState: TS.error);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800]),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('Select customer'),
            ),
    );
  }
}

TableCell cell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
        ),
      ),
    );
TableCell titleCell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
Widget text(String value, {TextAlign? align}) => Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        value,
        textAlign: align ?? TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
