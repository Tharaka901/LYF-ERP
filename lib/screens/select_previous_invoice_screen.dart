import 'package:flutter/material.dart';
import 'package:gsr/screens/previous_add_payment_screen.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/balance.dart';
import '../models/customer.dart';
import '../models/invoice/invoice_model.dart';
import '../models/issued_invoice_paid_model/issued_invoice_paid.dart';
import '../providers/data_provider.dart';
import '../services/database.dart';
import '../widgets/customer_deposite_paid_for_prevoius_invoice.dart';
import '../widgets/previous_invoice_form.dart';

class SelectPreviousInvoiceScreen extends StatefulWidget {
  final bool? isDirectPrevoius;
  final String? overPaymentAmount;
  const SelectPreviousInvoiceScreen(
      {super.key, this.isDirectPrevoius = true, this.overPaymentAmount = '0'});

  @override
  State<SelectPreviousInvoiceScreen> createState() =>
      _SelectPreviousInvoiceScreenState();
}

class _SelectPreviousInvoiceScreenState
    extends State<SelectPreviousInvoiceScreen> {
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
                  Text(
                    selectedCustomer.businessName ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (!widget.isDirectPrevoius!)
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Text(
                            'Over payment:',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.green[700]),
                          ),
                          const Spacer(),
                          Text(
                            widget.overPaymentAmount.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ),
                  if (!widget.isDirectPrevoius!)
                    const SizedBox(
                      height: 15,
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
                                                    '${element.invoiceNo}  ${element.creditValue != null ? formatPrice(element.creditValue!) : ''}',
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
                                                      text: data.selectedInvoice!
                                                                  .creditValue !=
                                                              null
                                                          ? data
                                                              .selectedInvoice!
                                                              .creditValue!
                                                              .toString()
                                                          : '');
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
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: OutlinedButton(
                      onPressed: () {
                        final paymentController = TextEditingController();
                        final formKey = GlobalKey<FormState>();
                        callBack(Balance selectedBalance) {}
                        confirm(
                          context,
                          title: 'Over Payment Invoices',
                          body: CustomerDepositePaidForPriviousInvoice(
                            paymentController: paymentController,
                            formKey: formKey,
                            callBack: callBack,
                          ),
                          onConfirm: () async {
                            if (formKey.currentState!.validate()) {
                              waiting(context, body: 'Sending...');
                              try {
                                await respo(
                                  'over-payment/update',
                                  method: Method.put,
                                  data: {
                                    "overPaymentsPayList": [
                                      {
                                        "value": (dataProvider
                                                    .selectedDeposite?.value ??
                                                0) -
                                            double.parse(
                                                paymentController.text),
                                        "customerId": dataProvider
                                            .selectedCustomer?.customerId,
                                        "paymentInvoiceId": dataProvider
                                            .selectedDeposite!.paymentInvoiceId,
                                        "receiptNo": dataProvider
                                                    .selectedDeposite?.status ==
                                                2
                                            ? dataProvider
                                                .selectedDeposite!.receiptNo
                                            : null
                                      }
                                    ]
                                  },
                                );
                                final response = await respo(
                                    'customers/get-by-reg-id',
                                    method: Method.post,
                                    data: {
                                      "registrationId":
                                          selectedCustomer.registrationId
                                    });
                                final customer =
                                    Customer.fromJson(response.data);
                                await respo(
                                  'customers/update',
                                  method: Method.put,
                                  data: {
                                    "customerId": selectedCustomer.customerId,
                                    "depositBalance": customer.depositBalance -
                                        double.parse(paymentController.text),
                                  },
                                );
                                final data = {
                                  "value": double.parse(paymentController.text),
                                  "paymentInvoiceId":
                                      dataProvider.selectedDeposite!.status == 2
                                          ? dataProvider.selectedDeposite!.id
                                          : dataProvider.selectedDeposite!.id,
                                  "routecardId": dataProvider
                                      .currentRouteCard!.routeCardId,
                                  "creditInvoiceId": dataProvider
                                              .selectedInvoice!.chequeId !=
                                          null
                                      ? dataProvider.selectedInvoice!.chequeId
                                      : dataProvider.selectedInvoice!.invoiceId,
                                  "receiptNo":
                                      dataProvider.selectedDeposite!.receiptNo,
                                  "status": dataProvider
                                              .selectedInvoice!.chequeId !=
                                          null
                                      ? dataProvider.selectedDeposite!.status ==
                                              2
                                          ? 8
                                          : 5
                                      : dataProvider.selectedDeposite!.status ==
                                              2
                                          ? 6
                                          : 7,
                                  "createdAt": dataProvider
                                      .selectedDeposite?.createdAt
                                      .toString(),
                                  "type":
                                      dataProvider.selectedInvoice!.chequeId !=
                                              null
                                          ? "return-cheque"
                                          : 'default'
                                };
                                await respo('credit-payment/create',
                                    method: Method.post, data: data);

                                if (dataProvider.selectedInvoice!.creditValue !=
                                        null &&
                                    dataProvider
                                            .selectedInvoice!.creditValue! <=
                                        double.parse(paymentController.text) &&
                                    dataProvider.selectedInvoice?.chequeId ==
                                        null) {
                                  await respo('invoice/update',
                                      method: Method.put,
                                      data: {
                                        "invoiceId": dataProvider
                                            .selectedInvoice!.invoiceId,
                                        "status": 2
                                      });
                                }
                                if (dataProvider.selectedInvoice!.chequeId !=
                                    null) {
                                  if (dataProvider
                                              .selectedInvoice!.creditValue !=
                                          null &&
                                      dataProvider
                                              .selectedInvoice!.creditValue! <=
                                          double.parse(
                                              paymentController.text)) {
                                    await respo('cheque/update',
                                        method: Method.put,
                                        data: {
                                          "id": dataProvider
                                              .selectedInvoice!.chequeId,
                                          "isActive": 2,
                                          "balance": 0
                                        });
                                  } else {
                                    await respo('cheque/update',
                                        method: Method.put,
                                        data: {
                                          "id": dataProvider
                                              .selectedInvoice!.chequeId,
                                          "balance": dataProvider
                                                      .selectedInvoice!
                                                      .creditValue !=
                                                  null
                                              ? dataProvider.selectedInvoice!
                                                      .creditValue! -
                                                  double.parse(
                                                      paymentController.text)
                                              : 0
                                        });
                                  }
                                }

                                //! Update return cylinder invoice balance
                                if (dataProvider.selectedDeposite?.status ==
                                    2) {
                                  await respo('return-cylinder-invoice/update',
                                      method: Method.put,
                                      data: {
                                        "invoiceNo": dataProvider
                                            .selectedDeposite?.receiptNo,
                                        "balance": dataProvider
                                                .selectedDeposite!.value! -
                                            double.parse(
                                                paymentController.text),
                                        "status": dataProvider.selectedDeposite!
                                                        .value! -
                                                    double.parse(
                                                        paymentController
                                                            .text) ==
                                                0
                                            ? 2
                                            : 1
                                      });
                                }
                                paymentController.clear();
                                pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectPreviousInvoiceScreen()));
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                          },
                          confirmText: 'Add',
                        );
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
                        'Over Payment Settle',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Consumer<DataProvider>(
                      builder: (context, data, _) => data
                              .issuedInvoicePaidList.isNotEmpty
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Column(
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
                                                              .indexOf(
                                                                  invoice) +
                                                          1)
                                                      .toString(),
                                                  align: TextAlign.start,
                                                ),
                                                cell(
                                                  invoice.issuedInvoice
                                                              .createdAt !=
                                                          null
                                                      ? invoice.issuedInvoice
                                                              .createdAt!
                                                              .toString()
                                                              .split(' ')[0]
                                                      : '',
                                                  align: TextAlign.center,
                                                ),
                                                cell(invoice
                                                    .issuedInvoice.invoiceNo),
                                                cell(
                                                  formatPrice(
                                                          invoice.paymentAmount)
                                                      .replaceAll('Rs.', ''),
                                                  align: TextAlign.center,
                                                ),
                                                InkWell(
                                                  onTap: () => data
                                                      .removePaidIssuedInvoice(
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
                                        text(formatPrice(data
                                            .getTotalInvoicePaymentAmount())),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 10),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Consumer<DataProvider>(
                                        builder: (context, data, _) {
                                      // final currentBalance = _balance(data, cash: cash);
                                      return data
                                              .issuedDepositePaidList.isNotEmpty
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Table(
                                                    defaultColumnWidth:
                                                        const IntrinsicColumnWidth(),
                                                    children: [
                                                      TableRow(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        children: [
                                                          titleCell(
                                                            '#',
                                                            align:
                                                                TextAlign.start,
                                                          ),
                                                          titleCell(
                                                            'Date',
                                                            align: TextAlign
                                                                .center,
                                                          ),
                                                          titleCell(
                                                            'Invoice No:',
                                                            align: TextAlign
                                                                .center,
                                                          ),
                                                          titleCell(
                                                            'Payment',
                                                            align: TextAlign
                                                                .center,
                                                          ),
                                                          titleCell(
                                                            'X',
                                                            align: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                      ...data
                                                          .issuedDepositePaidList
                                                          .map(
                                                        (invoice) => TableRow(
                                                          children: [
                                                            cell(
                                                              (data.issuedDepositePaidList
                                                                          .indexOf(
                                                                              invoice) +
                                                                      1)
                                                                  .toString(),
                                                              align: TextAlign
                                                                  .start,
                                                            ),
                                                            cell(
                                                              date(
                                                                  invoice
                                                                      .issuedDeposite
                                                                      .createdAt!,
                                                                  format:
                                                                      'dd-MM-yyyy'),
                                                              align: TextAlign
                                                                  .center,
                                                            ),
                                                            cell(invoice
                                                                .issuedDeposite
                                                                .paymentInvoiceId
                                                                .toString()),
                                                            cell(
                                                              formatPrice(invoice
                                                                      .paymentAmount)
                                                                  .replaceAll(
                                                                      'Rs.',
                                                                      ''),
                                                              align: TextAlign
                                                                  .center,
                                                            ),
                                                            InkWell(
                                                              onTap: () => data
                                                                  .removePaidDepositeInvoice(
                                                                      invoice),
                                                              child: const Icon(
                                                                Icons
                                                                    .clear_rounded,
                                                                color:
                                                                    Colors.red,
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
                                                    text('Total Over Payment'),
                                                    const Spacer(),
                                                    text(formatPrice(data
                                                        .getTotalDepositePaymentAmount())),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                              ],
                                            )
                                          : SizedBox();
                                    }),
                                    SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55.0,
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PreviousAddPaymentScreen())),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue[800]),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Pay',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : dummy)
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
