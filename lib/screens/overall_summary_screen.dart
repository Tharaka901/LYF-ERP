import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

import '../models/payment/payment_model.dart';

class OverallSummaryScreen extends StatefulWidget {
  static const routeId = 'O_SUMMARY';
  const OverallSummaryScreen({Key? key}) : super(key: key);

  @override
  State<OverallSummaryScreen> createState() => _OverallSummaryScreenState();
}

class _OverallSummaryScreenState extends State<OverallSummaryScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: defaultPadding,
          child: Column(
            children: [
              const Text(
                'Cash',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FutureBuilder<List<PaymentModel>>(
                future: getPayments(
                  context,
                  routecardId: dataProvider.currentRouteCard!.routeCardId!,
                  paymentMethod: 1,
                ),
                builder: (context, AsyncSnapshot<List<PaymentModel>> snapshot) {
                  var cashTotal = 0.0;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final payments = snapshot.data!;
                    for (var payment in payments) {
                      cashTotal += payment.amount ?? 0;
                    }
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Table(
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                children: [
                                  titleCell(
                                    'Receipt No',
                                    align: TextAlign.start,
                                  ),
                                  titleCell(
                                    'Customer Name',
                                    align: TextAlign.start,
                                  ),
                                  titleCell('Invoice No'),
                                  titleCell(
                                    'Amount',
                                    align: TextAlign.end,
                                  ),
                                ],
                              ),
                              ...payments.map(
                                (payment) => TableRow(
                                  children: [
                                    cell(
                                      payment.receiptNo ?? '',
                                      align: TextAlign.start,
                                    ),
                                    cell(
                                      payment.invoice?.customer?.businessName ??
                                          '',
                                      align: TextAlign.start,
                                    ),
                                    cell(payment.invoice!.invoiceNo.toString()),
                                    cell(
                                      payment.amount != null
                                          ? formatPrice(payment.amount!)
                                          : '',
                                      align: TextAlign.end,
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
                            text('Total cash:'),
                            const Spacer(),
                            text(formatPrice(cashTotal)),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                },
              ),
              const Divider(),
              const Text(
                'Cheque',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FutureBuilder<List<PaymentModel>>(
                future: getPayments(
                  context,
                  routecardId: dataProvider.currentRouteCard!.routeCardId!,
                  paymentMethod: 2,
                ),
                builder: (context, AsyncSnapshot<List<PaymentModel>> snapshot) {
                  var chequeTotal = 0.0;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final payments = snapshot.data!;
                    for (var payment in payments) {
                      chequeTotal += payment.amount ?? 0;
                    }
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Table(
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                children: [
                                  titleCell(
                                    'Receipt No',
                                    align: TextAlign.start,
                                  ),
                                  titleCell(
                                    'Customer Name',
                                    align: TextAlign.start,
                                  ),
                                  titleCell('Invoice No'),
                                  titleCell('Cheque No'),
                                  titleCell(
                                    'Amount',
                                    align: TextAlign.end,
                                  ),
                                ],
                              ),
                              ...payments.map(
                                (payment) => TableRow(
                                  children: [
                                    cell(
                                      payment.receiptNo ?? '',
                                      align: TextAlign.start,
                                    ),
                                    cell(
                                      payment.invoice?.customer?.businessName ??
                                          '',
                                      align: TextAlign.start,
                                    ),
                                    cell(payment.invoice!.invoiceNo.toString()),
                                    cell(payment.chequeNo!),
                                    cell(
                                      payment.amount != null
                                          ? formatPrice(payment.amount!)
                                          : '',
                                      align: TextAlign.end,
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
                            text('Total cheque:'),
                            const Spacer(),
                            text(formatPrice(chequeTotal)),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                },
              ),
              const Divider(),
              const Text(
                'Voucher',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FutureBuilder<List<PaymentModel>>(
                future: getPayments(
                  context,
                  routecardId: dataProvider.currentRouteCard!.routeCardId!,
                  paymentMethod: 3,
                ),
                builder: (context, AsyncSnapshot<List<PaymentModel>> snapshot) {
                  var voucherTotal = 0.0;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final payments = snapshot.data!;
                    for (var payment in payments) {
                      voucherTotal += payment.amount ?? 0;
                    }
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Table(
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                children: [
                                  titleCell(
                                    'Receipt No',
                                    align: TextAlign.start,
                                  ),
                                  titleCell(
                                    'Customer Name',
                                    align: TextAlign.start,
                                  ),
                                  titleCell('Invoice No'),
                                  titleCell('Voucher code'),
                                  titleCell(
                                    'Amount',
                                    align: TextAlign.end,
                                  ),
                                ],
                              ),
                              ...payments
                                  .where((element) => element.amount != 0)
                                  .map(
                                    (payment) => TableRow(
                                      children: [
                                        cell(
                                          payment.receiptNo ?? '',
                                          align: TextAlign.start,
                                        ),
                                        cell(
                                            payment.invoice?.customer
                                                  ?.businessName ??
                                              '',
                                          align: TextAlign.start,
                                        ),
                                        cell(payment.invoice!.invoiceNo
                                            .toString()),
                                        cell(payment.chequeNo ?? '-'),
                                        cell(
                                          payment.amount != null
                                              ? formatPrice(payment.amount!)
                                              : '',
                                          align: TextAlign.end,
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
                            text('Total voucher:'),
                            const Spacer(),
                            text(formatPrice(voucherTotal)),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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
  Widget text(String value) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
