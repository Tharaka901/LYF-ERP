import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/balance.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/print/print_invoice_view.dart';
import 'package:gsr/providers/items_provider.dart';
import 'package:gsr/widgets/credit_invoice.dart';
import 'package:gsr/widgets/customer_deposite_paid.dart';
import 'package:provider/provider.dart';

import '../../providers/payment_provider.dart';
import '../../widgets/confirm_for_save_and_print.dart';
import '../invoice/invoice_provider.dart';
import '../select_customer/select_customer_screen.dart';
import 'invoice_receipt_view_model.dart';

class InvoiceReceiptScreen extends StatefulWidget {
  static const routeId = 'RECEIPT';
  const InvoiceReceiptScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InvoiceReceiptScreen> createState() => _InvoiceReceiptScreenState();
}

class _InvoiceReceiptScreenState extends State<InvoiceReceiptScreen> {
  PaymentProvider? paymentProvider;
  final TextEditingController receiptNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    paymentProvider!.getReceiptNumber(context);
    super.initState();
  }

  _balance(DataProvider data, {required double cash}) {
    return data.getTotalChequeAmount() +
        cash +
        (data.selectedVoucher != null ? data.selectedVoucher!.value : 0.0) -
        (data.grandTotal) -
        data.getTotalCreditPaymentAmount() +
        data.getTotalDepositePaymentAmount();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceReceiptViewModel = InvoiceReceiptViewModel();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final itemProvider = Provider.of<ItemsProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    final double cash = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['cash'];
    // final Respo invoiceRes = Respo(success: true);
    final isManual = (ModalRoute.of(context)!.settings.arguments
            as Map<String, dynamic>)['isManual'] ??
        false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
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
                                    dataProvider.selectedCustomer!.businessName ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18.0),
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
                                    'Customer VAT ID:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    dataProvider
                                            .selectedCustomer!.customerVat ??
                                        '-',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18.0),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            if (!isManual)
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
                                      builder: (context, paymentProvider, _) =>
                                          Text(
                                        paymentProvider.receiptNumber != null
                                            ? paymentProvider.receiptNumber!
                                            : 'Generating...',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'Invoice No:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    invoiceProvider.invoiceNu ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ),
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
                                price(cheque.chequeAmount)
                                    .replaceAll('Rs.', ''),
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
                                            dataProvider
                                                    .selectedVoucher!.value ==
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
                                            dataProvider
                                                    .selectedVoucher!.value ==
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
                              'Total Payment:',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              price(dataProvider.getTotalChequeAmount() +
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
                              'Invoice Amount:',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              price(dataProvider.grandTotal),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<DataProvider>(
                        builder: (context, data, _) => data
                                .paidBalanceList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Total previous invoice payment:',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      price(data.getTotalCreditPaymentAmount()),
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : dummy,
                      ),
                      Consumer<DataProvider>(
                        builder: (context, data, _) {
                          final currentBalance = _balance(data, cash: cash);
                          return currentBalance != 0
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        currentBalance > 0
                                            ? 'Over payment:'
                                            : 'Credit:',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: currentBalance > 0
                                              ? Colors.green[700]
                                              : Colors.red,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (dataProvider
                                          .issuedInvoicePaidList.isNotEmpty)
                                        Text(
                                          price(currentBalance < 0
                                              ? -currentBalance
                                              : currentBalance -
                                                  (dataProvider
                                                          .issuedInvoicePaidList
                                                          .map((e) =>
                                                              e.paymentAmount)
                                                          .toList())
                                                      .reduce(
                                                          (value, element) =>
                                                              value + element)),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: currentBalance > 0
                                                ? Colors.green[700]
                                                : Colors.red,
                                          ),
                                        ),
                                      if (!dataProvider
                                          .issuedInvoicePaidList.isNotEmpty)
                                        Text(
                                          price(currentBalance < 0
                                              ? -currentBalance
                                              : currentBalance),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: currentBalance > 0
                                                ? Colors.green[700]
                                                : Colors.red,
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : dummy;
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Consumer<DataProvider>(
                  builder: (context, data, _) => data.paidBalanceList.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Previous Invoices',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: Table(
                                  border: TableBorder.all(),
                                  defaultColumnWidth:
                                      const IntrinsicColumnWidth(),
                                  children: [
                                    const TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'Invoice No:',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'Credit (Rs)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'Payment (Rs)',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'Action',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...data.paidBalanceList.map(
                                      (paidBalance) => TableRow(
                                        children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                paidBalance
                                                    .balance.invoice.invoiceNo,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                price(-paidBalance
                                                        .balance.balanceAmount)
                                                    .replaceAll('Rs.', ''),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                price(paidBalance.payment)
                                                    .replaceAll('Rs.', ''),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => data
                                                .removePaidBalance(paidBalance),
                                            icon: const Icon(
                                              Icons.clear_rounded,
                                              color: defaultErrorColor,
                                            ),
                                            splashRadius: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : dummy,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(height: 5),
                if (isManual)
                  TextFormField(
                    controller: receiptNoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Receipt Number',
                    ),
                    style: defaultTextFieldStyle,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Receipt Number cannot be empty!';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                Consumer<DataProvider>(
                  builder: (context, data, _) {
                    final currentBalance = _balance(data, cash: cash);
                    return currentBalance > 0
                        ? SizedBox(
                            width: double.infinity,
                            height: 60.0,
                            child: OutlinedButton(
                              onPressed: () {
                                final paymentController =
                                    TextEditingController();
                                final formKey = GlobalKey<FormState>();
                                callBack(Balance selectedBalance) {}
                                confirm(
                                  context,
                                  title: 'Previous Invoice',
                                  body: CreditInvoice(
                                    paymentController: paymentController,
                                    formKey: formKey,
                                    callBack: callBack,
                                    balance: currentBalance,
                                  ),
                                  onConfirm: () {
                                    if (formKey.currentState!.validate()) {
                                      paymentController.clear();
                                      return;
                                    }
                                  },
                                  confirmText: 'Add',
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[600]),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Previous payment',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 60.0,
                            child: OutlinedButton(
                              onPressed: () {
                                final paymentController =
                                    TextEditingController();
                                final formKey = GlobalKey<FormState>();
                                callBack(Balance selectedBalance) {}
                                confirm(
                                  context,
                                  title: 'Previous Invoices',
                                  body: CustomerDepositePaid(
                                    paymentController: paymentController,
                                    formKey: formKey,
                                    callBack: callBack,
                                    balnce: currentBalance,
                                  ),
                                  onConfirm: () {
                                    if (formKey.currentState!.validate()) {
                                      paymentController.clear();
                                      return;
                                    }
                                  },
                                  confirmText: 'Add',
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[600]),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Previous Payment',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Consumer<DataProvider>(builder: (context, data, _) {
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
                                      borderRadius: BorderRadius.circular(5.0),
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
                                  ...data.issuedDepositePaidList.map(
                                    (invoice) => TableRow(
                                      children: [
                                        cell(
                                          (data.issuedDepositePaidList
                                                      .indexOf(invoice) +
                                                  1)
                                              .toString(),
                                          align: TextAlign.start,
                                        ),
                                        cell(
                                          date(
                                              invoice.issuedDeposite.createdAt!,
                                              format: 'dd-MM-yyyy'),
                                          align: TextAlign.center,
                                        ),
                                        cell(invoice
                                            .issuedDeposite.paymentInvoiceId
                                            .toString()),
                                        cell(
                                          price(invoice.paymentAmount)
                                              .replaceAll('Rs.', ''),
                                          align: TextAlign.center,
                                        ),
                                        InkWell(
                                          onTap: () =>
                                              data.removePaidDepositeInvoice(
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
                                text('Total Previous Payment'),
                                const Spacer(),
                                text(price(
                                    data.getTotalDepositePaymentAmount())),
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
                Consumer<DataProvider>(builder: (context, data, _) {
                  final currentBalance = _balance(data, cash: cash);
                  return data.issuedInvoicePaidList.isNotEmpty
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
                                      borderRadius: BorderRadius.circular(5.0),
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
                                          invoice.issuedInvoice.createdAt.toString().split(' ')[0],
                                          align: TextAlign.center,
                                        ),
                                        cell(invoice.issuedInvoice.invoiceNo),
                                        cell(
                                          price(invoice.paymentAmount)
                                              .replaceAll('Rs.', ''),
                                          align: TextAlign.center,
                                        ),
                                        InkWell(
                                          onTap: () => data
                                              .removePaidIssuedInvoice(invoice),
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
                                text('Total Previous Payment'),
                                const Spacer(),
                                text(
                                    price(data.getTotalInvoicePaymentAmount())),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 60.0,
                              child: OutlinedButton(
                                onPressed: () => confirmForSaveAndPrint(
                                  context,
                                  onSave: () async {
                                    pop(context);
                                    if (isManual) {
                                      if (formKey.currentState!.validate()) {
                                        waiting(context, body: 'Sending...');
                                        await invoiceReceiptViewModel.pay(
                                          context: context,
                                          cash: cash,
                                          balance: currentBalance -
                                              (dataProvider
                                                      .issuedInvoicePaidList
                                                      .map((e) =>
                                                          e.paymentAmount)
                                                      .toList())
                                                  .reduce((value, element) =>
                                                      value + element),
                                          receiptNo:
                                              receiptNoController.text.trim(),
                                          isOnlySave: true,
                                        );
                                        itemProvider.clearData();
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                SelectCustomerView.routeId));
                                      }
                                    } else {
                                      waiting(context, body: 'Sending...');
                                      await invoiceReceiptViewModel.pay(
                                        context: context,
                                        cash: cash,
                                        balance: currentBalance -
                                            (dataProvider.issuedInvoicePaidList
                                                    .map((e) => e.paymentAmount)
                                                    .toList())
                                                .reduce((value, element) =>
                                                    value + element),
                                        isOnlySave: true,
                                      );
                                      itemProvider.clearData();
                                      Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              SelectCustomerView.routeId));
                                    }
                                  },
                                  onSaveAndPrint: () async {
                                    pop(context);
                                    if (isManual) {
                                      if (formKey.currentState!.validate()) {
                                        Future<void> onSaveData() async {
                                          waiting(context, body: 'Sending...');
                                          await invoiceReceiptViewModel.pay(
                                            context: context,
                                            cash: cash,
                                            balance: currentBalance -
                                                (dataProvider
                                                        .issuedInvoicePaidList
                                                        .map((e) =>
                                                            e.paymentAmount)
                                                        .toList())
                                                    .reduce((value, element) =>
                                                        value + element),
                                            receiptNo:
                                                receiptNoController.text.trim(),
                                          );
                                          itemProvider.clearData();
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrintInvoiceView(
                                              invoiceNo:
                                                  invoiceProvider.invoiceNu!,
                                              rn: receiptNoController.text
                                                  .trim(),
                                              cash: cash,
                                              balance: currentBalance,
                                              isBillingFrom: true,
                                              onSaveData: onSaveData,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      Future<void> onSaveData() async {
                                        waiting(context, body: 'Sending...');
                                        await invoiceReceiptViewModel.pay(
                                          context: context,
                                          cash: cash,
                                          balance: currentBalance -
                                              (dataProvider
                                                      .issuedInvoicePaidList
                                                      .map((e) =>
                                                          e.paymentAmount)
                                                      .toList())
                                                  .reduce((value, element) =>
                                                      value + element),
                                        );
                                        itemProvider.clearData();
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PrintInvoiceView(
                                            invoiceNo:
                                                invoiceProvider.invoiceNu!,
                                            rn: paymentProvider
                                                    ?.receiptNumber ??
                                                '',
                                            cash: cash,
                                            balance: currentBalance -
                                                (dataProvider
                                                        .issuedInvoicePaidList
                                                        .map((e) =>
                                                            e.paymentAmount)
                                                        .toList())
                                                    .reduce((value, element) =>
                                                        value + element),
                                            isBillingFrom: true,
                                            onSaveData: onSaveData,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green[700]),
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
                        )
                      : Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 60.0,
                              child: OutlinedButton(
                                onPressed: () => confirmForSaveAndPrint(
                                  context,
                                  onSave: () async {
                                    pop(context);
                                    if (isManual) {
                                      if (formKey.currentState!.validate()) {
                                        waiting(context, body: 'Sending...');
                                        await invoiceReceiptViewModel
                                            .pay(
                                              context: context,
                                              cash: cash,
                                              balance: currentBalance,
                                              receiptNo: receiptNoController
                                                  .text
                                                  .trim(),
                                              isOnlySave: true,
                                            )
                                            .then((value) => {
                                                  pop(context),
                                                  itemProvider.clearData(),
                                                  Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                          SelectCustomerView
                                                              .routeId))
                                                });
                                      }
                                    } else {
                                      await invoiceReceiptViewModel
                                          .pay(
                                            context: context,
                                            cash: cash,
                                            balance: currentBalance,
                                            isOnlySave: true,
                                          )
                                          .then((value) => {
                                                pop(context),
                                                itemProvider.clearData(),
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        SelectCustomerView
                                                            .routeId))
                                              });
                                    }
                                  },
                                  onSaveAndPrint: () async {
                                    pop(context);
                                    if (isManual) {
                                      Future<void> onSaveData() async {
                                        await invoiceReceiptViewModel.pay(
                                          context: context,
                                          cash: cash,
                                          balance: currentBalance,
                                          receiptNo:
                                              receiptNoController.text.trim(),
                                        );
                                        itemProvider.clearData();
                                      }

                                      if (formKey.currentState!.validate()) {
                                        //pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrintInvoiceView(
                                              invoiceNo:
                                                  invoiceProvider.invoiceNu!,
                                              rn: receiptNoController.text
                                                  .trim(),
                                              cash: cash,
                                              balance: currentBalance,
                                              isBillingFrom: true,
                                              onSaveData: onSaveData,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      Future<void> onSaveData() async {
                                        waiting(context, body: 'Sending...');
                                        await invoiceReceiptViewModel.pay(
                                          context: context,
                                          cash: cash,
                                          balance: currentBalance,
                                        );
                                        itemProvider.clearData();
                                      }

                                      //pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PrintInvoiceView(
                                            invoiceNo:
                                                invoiceProvider.invoiceNu!,
                                            rn: paymentProvider
                                                    ?.receiptNumber ??
                                                '',
                                            cash: cash,
                                            balance: currentBalance,
                                            isBillingFrom: true,
                                            onSaveData: onSaveData,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green[700]),
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
                            SizedBox(height: 15),
                          ],
                        );
                }),
              ],
            ),
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
