import 'package:flutter/material.dart';
import 'package:gsr/modules/previous_add_payment/previous_add_payment_screen.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/balance.dart';
import '../../models/invoice/invoice_model.dart';
import '../../models/issued_invoice_paid_model/issued_invoice_paid.dart';
import '../../providers/data_provider.dart';
import '../../widgets/popups/customer_deposite_paid_for_prevoius_invoice.dart';
import '../../widgets/previous_invoice_form.dart';
import '../view_receipt/invoice_receipt_view_model.dart';
import 'select_previous_invoice_view_model.dart';

class SelectPreviousInvoiceScreen extends StatefulWidget {
  final bool? isDirectPrevoius;
  final String? overPaymentAmount;
  const SelectPreviousInvoiceScreen(
      {Key? key, this.isDirectPrevoius = true, this.overPaymentAmount = '0'});

  @override
  State<SelectPreviousInvoiceScreen> createState() =>
      _SelectPreviousInvoiceScreenState();
}

class _SelectPreviousInvoiceScreenState
    extends State<SelectPreviousInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final invoiceReceiptViewModel = InvoiceReceiptViewModel();
    final selectPreviousInvoiceViewModel = SelectPreviousInvoiceViewModel();
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
                    selectedCustomer.businessName,
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
                    future: invoiceReceiptViewModel.getCreditInvoices(
                      context,
                      cId: dataProvider.selectedCustomer!.customerId,
                      type: 'with-cheque',
                    ),
                    builder:
                        (context, AsyncSnapshot<List<InvoiceModel>> snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: Form(
                                key: selectPreviousInvoiceViewModel
                                    .invoiceFormKey,
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
                                                      .invoiceNo ==
                                                  dataProvider.selectedInvoice!
                                                      .invoiceNo)
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
                                            if (selectPreviousInvoiceViewModel
                                                .invoiceFormKey.currentState!
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

                  //! Pay privious invoice from customer deposites
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
                                selectPreviousInvoiceViewModel.payFromDeposite(
                                    context, paymentController);
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
                                              'invoice.issuedInvoice.createdAt!',
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
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Consumer<DataProvider>(
                                    builder: (context, data, _) {
                                  // final currentBalance = _balance(data, cash: cash);
                                  return data.issuedDepositePaidList.isNotEmpty
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
                                                          BorderRadius.circular(
                                                              5.0),
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
                                                  ...data.issuedDepositePaidList
                                                      .map(
                                                    (invoice) => TableRow(
                                                      children: [
                                                        cell(
                                                          (data.issuedDepositePaidList
                                                                      .indexOf(
                                                                          invoice) +
                                                                  1)
                                                              .toString(),
                                                          align:
                                                              TextAlign.start,
                                                        ),
                                                        cell(
                                                          date(
                                                              invoice
                                                                  .issuedDeposite
                                                                  .createdAt!,
                                                              format:
                                                                  'dd-MM-yyyy'),
                                                          align:
                                                              TextAlign.center,
                                                        ),
                                                        cell(invoice
                                                            .issuedDeposite
                                                            .paymentInvoiceId
                                                            .toString()),
                                                        cell(
                                                          price(invoice
                                                                  .paymentAmount)
                                                              .replaceAll(
                                                                  'Rs.', ''),
                                                          align:
                                                              TextAlign.center,
                                                        ),
                                                        InkWell(
                                                          onTap: () => data
                                                              .removePaidDepositeInvoice(
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
                                                text('Total Over Payment'),
                                                const Spacer(),
                                                text(price(data
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
