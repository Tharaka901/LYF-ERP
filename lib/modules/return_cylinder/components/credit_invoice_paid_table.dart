import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/components/text_containers.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:provider/provider.dart';

class CreditInvoicePaidTable extends StatefulWidget {
  const CreditInvoicePaidTable({super.key});

  @override
  State<CreditInvoicePaidTable> createState() => _CreditInvoicePaidTableState();
}

class _CreditInvoicePaidTableState extends State<CreditInvoicePaidTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectCreditInvoiceProvider>(
        builder: (context, data, _) => data.paidIssuedInvoices.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(),
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
                        ...data.paidIssuedInvoices.map(
                          (invoice) => TableRow(
                            children: [
                              cell(
                                (data.paidIssuedInvoices.indexOf(invoice) + 1)
                                    .toString(),
                                align: TextAlign.start,
                              ),
                              cell(
                                invoice.issuedInvoice.routeCard?.date?.toString().split(' ')[0] ?? 'No Date',
                                align: TextAlign.center,
                              ),
                              cell(invoice.issuedInvoice.invoiceNo),
                              cell(
                                formatPrice(invoice.paymentAmount)
                                    .replaceAll('Rs.', ''),
                                align: TextAlign.center,
                              ),
                              InkWell(
                                onTap: () =>
                                    data.removePaidIssuedInvoice(invoice),
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
                      const TextContainer(text: 'Total Payment'),
                      const Spacer(),
                      TextContainer(
                          text: formatPrice(data.totalInvoicePaymentAmount)),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : const SizedBox.shrink());
  }
}
