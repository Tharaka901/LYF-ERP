import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/providers/payment_provider.dart';
import 'package:gsr/widgets/confirm_for_save_and_print.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../previous_customer_select/previous_screen.dart';
import '../print/print_invoice_view.dart';
import 'invoice_receipt_view_model.dart';

class PreviousViewReceiptScreen extends StatefulWidget {
  static const routeId = 'PREVIOUS_RECEIPT';
  const PreviousViewReceiptScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PreviousViewReceiptScreen> createState() =>
      _PreviousViewReceiptScreenState();
}

class _PreviousViewReceiptScreenState extends State<PreviousViewReceiptScreen> {
  PaymentProvider? paymentProvider;
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    paymentProvider!.getReceiptNumber(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceReceiptViewModel = InvoiceReceiptViewModel();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final double cash = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['cash'];
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Receipt',
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                child: dataProvider.selectedCustomer != null
                    ? Column(
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
                                  date(DateTime.now(), format: 'dd.MM.yyyy'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Customer name:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                    dataProvider.selectedCustomer!.businessName,
                                    // textAlign: TextAlign.,
                                    style: const TextStyle(fontSize: 18.0),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip),
                              ),
                            ],
                          ),
                          Consumer<DataProvider>(builder: (context, data, _) {
                            return Column(
                              children: [
                                if (!dataProvider.isManualReceipt)
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          'Receipt No:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Consumer<PaymentProvider>(
                                          builder:
                                              (context, paymentProvider, _) =>
                                                  Text(
                                            paymentProvider.receiptNumber !=
                                                    null
                                                ? paymentProvider.receiptNumber!
                                                : 'Generating...',
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          }),
                        ],
                      )
                    : dummy,
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
                            'Invoice No',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Amount (Rs)',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...dataProvider.issuedInvoicePaidList.map(
                      (invoice) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              invoice.issuedInvoice.invoiceNo.toString(),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              price(invoice.paymentAmount)
                                  .replaceAll('Rs.', ''),
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                            'Method',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Cheque No:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Amount (Rs)',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Cash',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            price(cash).replaceAll('Rs.', ''),
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    if (dataProvider.getTotalDepositePaymentAmount() != 0)
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Over Payment Pay',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              '-',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              price(dataProvider
                                      .getTotalDepositePaymentAmount())
                                  .replaceAll('Rs.', ''),
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ...dataProvider.chequeList.map(
                      (cheque) => TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Cheque',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              cheque.chequeNumber,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              price(cheque.chequeAmount).replaceAll('Rs.', ''),
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    dataProvider.selectedVoucher != null
                        ? TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Voucher',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  (dataProvider.selectedVoucher == null ||
                                          dataProvider.selectedVoucher!.value ==
                                              0)
                                      ? '-'
                                      : dataProvider.selectedVoucher!.code,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  (dataProvider.selectedVoucher == null ||
                                          dataProvider.selectedVoucher!.value ==
                                              0)
                                      ? '0.00'
                                      : price(dataProvider
                                              .selectedVoucher!.value)
                                          .replaceAll('Rs.', ''),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          )
                        : TableRow(children: [
                            dummy,
                            dummy,
                            dummy,
                          ]),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const Text(
                            'Total payment:',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            price(dataProvider.getTotalChequeAmount() +
                                dataProvider.getTotalDepositePaymentAmount() +
                                cash +
                                (dataProvider.selectedVoucher != null
                                    ? dataProvider.selectedVoucher!.value
                                    : 0.0)),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const Text(
                            'Invoice amount:',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            price(dataProvider.getTotalInvoicePaymentAmount()),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
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
              Consumer<DataProvider>(builder: (context, data, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Manual Receipt'),
                        value: dataProvider.isManualReceipt,
                        onChanged: (bool? value) {
                          dataProvider.setManualReceipt(value ?? false);
                        },
                      ),
                      if (dataProvider.isManualReceipt)
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Receipt No',
                          ),
                          style: const TextStyle(fontSize: 20.0),
                        ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 60.0,
                child: Consumer<PaymentProvider>(
                    builder: (context, paymentProvider, _) {
                  return paymentProvider.receiptNumber == null
                      ? CircularProgressIndicator(
                          value: 10,
                        )
                      : OutlinedButton(
                          onPressed: () =>
                              confirmForSaveAndPrint(context, onSave: () async {
                            pop(context);
                            if (dataProvider.isManualReceipt &&
                                _usernameController.text.isEmpty) {
                              toast(
                                'Receipt no is required.',
                                toastState: TS.error,
                              );
                              return;
                            }
                            waiting(context, body: 'Sending...');
                            await invoiceReceiptViewModel
                                .pay(
                              context: context,
                              cash: cash,
                              isDirectPrevious: false,
                              balance: 0,
                              receiptNo: dataProvider.isManualReceipt
                                  ? _usernameController.text
                                  : null,
                            )
                                .then((value) {
                              Navigator.popUntil(context,
                                  ModalRoute.withName(PreviousScreen.routeId));
                              toast(
                                'Sent successfully',
                                toastState: TS.success,
                              );
                            });
                          }, onSaveAndPrint: () {
                            pop(context);
                            if (dataProvider.isManualReceipt &&
                                _usernameController.text.isEmpty) {
                              toast(
                                'Receipt no is required.',
                                toastState: TS.error,
                              );
                              return;
                            }

                            Future<void> onSaveData() async {
                              waiting(context, body: 'Sending...');
                              await sendCreditPayment(
                                  context,
                                  dataProvider.getTotalChequeAmount() +
                                      cash +
                                      (dataProvider.selectedVoucher != null
                                          ? dataProvider.selectedVoucher!.value
                                          : 0.0),
                                  cash,
                                  false,
                                  0,
                                  receiptNo: dataProvider.isManualReceipt
                                      ? _usernameController.text
                                      : null);

                              dataProvider.issuedDepositePaidList.clear();
                              dataProvider.chequeList.clear();
                              dataProvider.issuedInvoicePaidList.clear();
                              dataProvider.itemList.clear();
                              Navigator.popUntil(context,
                                  ModalRoute.withName(PreviousScreen.routeId));
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrintInvoiceView(
                                  invoiceNo: '0',
                                  rn: dataProvider.isManualReceipt
                                      ? _usernameController.text
                                      : paymentProvider.receiptNumber!,
                                  cash: cash,
                                  balance: 0,
                                  type: 'previous',
                                  isBillingFrom: true,
                                  onSaveData: onSaveData,
                                ),
                              ),
                            );
                          }),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[700]),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                        );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
