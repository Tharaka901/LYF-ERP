import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/credit_payment/credit_payment_model.dart';
import 'package:gsr/modules/receipt_summary/receipt_summary_provider.dart';
import 'package:gsr/screens/select_previous_invoice_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

class ReceiptSummaryView extends StatefulWidget {
  final CreditPaymentModel creditPayment;
  const ReceiptSummaryView({Key? key, required this.creditPayment});

  @override
  State<ReceiptSummaryView> createState() => _ReceiptSummaryViewState();
}

class _ReceiptSummaryViewState extends State<ReceiptSummaryView> {
  ReceiptSummaryProvider? receiptSummaryProvider;
  @override
  void initState() {
    receiptSummaryProvider =
        Provider.of<ReceiptSummaryProvider>(context, listen: false);
    receiptSummaryProvider!.getCreditPayments(context, widget.creditPayment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Receipt Summary'),
          actions: [
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () {
                receiptSummaryProvider!.onPressedPrintButton(context);
              },
            )
          ],
        ),
        body: Consumer(
          builder: (context, rsp, _) => receiptSummaryProvider!.receiptModel ==
                  null
              ? Center(child: CircularProgressIndicator())
              : FutureBuilder<List<CreditPaymentModel>>(
                  future: getCreditPaymentsByReceipt(
                      receiptNo: widget.creditPayment.receiptNo!),
                  builder: (context, AsyncSnapshot<List<CreditPaymentModel>> snapshot) {
                    return snapshot.hasData
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
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
                                      child: Text(
                                        snapshot.data![0].receiptNo ?? '',
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
                                        snapshot.data![0].createdAt == null
                                            ? '-'
                                            : date(snapshot.data![0].createdAt!,
                                                format: 'dd.MM.yyyy'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                        ],
                                      ),
                                      ...snapshot.data!.map(
                                        (invoice) => TableRow(
                                          children: [
                                            cell(
                                              (snapshot.data!.indexOf(invoice) +
                                                      1)
                                                  .toString(),
                                              align: TextAlign.start,
                                            ),
                                            cell(
                                              invoice.creditInvoice
                                                          ?.createdAt ==
                                                      null
                                                  ? '-'
                                                  : date(
                                                      DateTime.parse(
                                                          invoice.creditInvoice!
                                                              .createdAt!),
                                                      format: 'dd-MM-yyyy'),
                                              align: TextAlign.center,
                                            ),
                                            cell(invoice
                                                .creditInvoice!.invoiceNo),
                                            cell(
                                              invoice.value != null
                                                  ? formatPrice(invoice.value!)
                                                      .replaceAll('Rs.', '')
                                                  : '',
                                              align: TextAlign.center,
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Table(
                                    children: [
                                      TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                        ),
                                        children: [
                                          titleCell(
                                            'Method',
                                            align: TextAlign.start,
                                          ),
                                          titleCell(
                                            'Check No:',
                                            align: TextAlign.center,
                                          ),
                                          titleCell(
                                            'Amount (Rs)',
                                            align: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      ...snapshot.data![0].payments!.map(
                                        (payment) => TableRow(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                payment.paymentMethod == 1
                                                    ? 'Cash'
                                                    : payment.paymentMethod == 2
                                                        ? 'Cheque'
                                                        : 'Voucher',
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                payment.chequeNo ?? '-',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                payment.amount != null
                                                    ? formatPrice(payment.amount!)
                                                        .replaceAll('Rs.', '')
                                                    : '',
                                                textAlign: TextAlign.end,
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          text(
                                            'Total payment',
                                            align: TextAlign.end,
                                          ),
                                          const Spacer(),
                                          text(formatPrice(snapshot.data!
                                              .map((e) => e.value!)
                                              .toList()
                                              .reduce((value, current) =>
                                                  value! + current!))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          )
                        : snapshot.hasError
                            ? Center(
                                child: Text(snapshot.error.toString()),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                  }),
        ));
  }
}
