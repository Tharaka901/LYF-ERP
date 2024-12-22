import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/cheque/cheque.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/issued_invoice_paid_model/issued_invoice_paid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../providers/data_provider.dart';
import 'print_invoice_view_model.dart';

class PrintInvoiceView extends StatelessWidget {
  final String invoiceNo;
  final String rn;
  final double? cash;
  final double balance;
  final InvoiceModel? issuedInvoice;
  final List<AddedItem>? items;
  final List<ChequeModel>? cheques;
  final List<IssuedInvoicePaidModel>? previousPayments;
  final bool? isBillingFrom;
  final Future<void> Function()? onSaveData;
  final String? type;
  const PrintInvoiceView({
    super.key,
    required this.invoiceNo,
    required this.rn,
    this.cash,
    required this.balance,
    this.issuedInvoice,
    this.items,
    this.cheques,
    this.previousPayments,
    this.isBillingFrom,
    this.onSaveData,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final _viewModel = PrintInvoiceViewModel();
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Invoice'),
      ),
      body: PdfPreview(
        onPrinted: (context) async {
          if ((isBillingFrom ?? false) & (onSaveData != null))
            await onSaveData!();
          if (type != 'previous')
            _viewModel.onPrinted(context, isBillingFrom ?? false);
        },
        build: (format) => _generatePdf(format, context, rn),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, BuildContext context, String rn) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: ThemeConstants.pageFormat,
        build: (context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  //! Company details
                  ...CompanyConstants.companyDetails,

                  //! Invoice details
                  if (invoiceNo != '0') ...[
                    pw.SizedBox(height: 5.0),
                    pw.Text(
                      'Tax Invoice',
                      style: ThemeConstants.boldStyleForPdf,
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Bill to: ${issuedInvoice?.customer?.businessName ?? dataProvider.selectedCustomer!.businessName}',
                              style: pw.TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                            pw.Text(
                              'Customer Vat No: ${issuedInvoice?.customer?.customerVat ?? dataProvider.selectedCustomer!.customerVat ?? '-'}',
                              style: pw.TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                            pw.Text(
                              'Date: ${date(DateTime.parse(issuedInvoice!.createdAt!), format: 'dd.MM.yyyy')}',
                              style: pw.TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                            pw.Text(
                              'Invoice No: ${invoiceNo}',
                              style: pw.TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Table(
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromInt(0xFFFFFFFF),
                          ),
                          children: [
                            pwtitleCell(
                              '#',
                              align: pw.TextAlign.left,
                            ),
                            pwtitleCell('Item'),
                            pwtitleCell('Qty'),
                            pwtitleCell('Unit Price'),
                            pwtitleCell(
                              'Amount',
                              align: pw.TextAlign.right,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                            ),
                          ],
                        ),
                        ...(items ?? dataProvider.itemList).map((invoiceItem) {
                          return pw.TableRow(
                            children: [
                              pwcell(
                                ((items ?? dataProvider.itemList)
                                            .indexOf(invoiceItem) +
                                        1)
                                    .toString(),
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                invoiceItem.item.itemName,
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                num(invoiceItem.quantity),
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                price(invoiceItem.item.salePrice),
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                price(
                                  invoiceItem.quantity *
                                      invoiceItem.item.salePrice,
                                ),
                                align: pw.TextAlign.right,
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),
                    pw.SizedBox(height: 5),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total: ',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                          pwtitleCell(
                              price(double.parse(
                                  '${issuedInvoice?.subTotal?.toStringAsFixed(2) ?? dataProvider.getTotalAmount().toStringAsFixed(2)}')),
                              align: pw.TextAlign.left,
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              color: PdfColor.fromInt(0xFF000000)),
                        ],
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Vat 18%: ',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                          pwtitleCell(
                              price(double.parse(
                                  '${(issuedInvoice?.vat ?? (dataProvider.getTotalAmount() * 0.18)).toStringAsFixed(2)}')),
                              align: pw.TextAlign.left,
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              color: PdfColor.fromInt(0xFF000000)),
                        ],
                      ),
                    ),
                    if ((issuedInvoice?.nonVatItemTotal ??
                            (dataProvider.nonVatItemTotal)) !=
                        0)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(0),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Non VAT Item Amount: ',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            pwtitleCell(
                                price(double.parse(
                                    '${(issuedInvoice?.nonVatItemTotal ?? (dataProvider.nonVatItemTotal)).toStringAsFixed(2)}')),
                                align: pw.TextAlign.left,
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                color: PdfColor.fromInt(0xFF000000)),
                          ],
                        ),
                      ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Grand Total: ',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                          pwtitleCell(
                              price(double.parse(
                                  '${(issuedInvoice?.amount ?? (dataProvider.getTotalAmount() + dataProvider.nonVatItemTotal + dataProvider.getTotalAmount() * 0.18)).toStringAsFixed(2)}')),
                              align: pw.TextAlign.left,
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              color: PdfColor.fromInt(0xFF000000)),
                        ],
                      ),
                    )
                  ],

                  // //! Payment section
                  if (issuedInvoice?.payments!.isNotEmpty ??
                      false ||
                          cash != null ||
                          dataProvider.chequeList.isNotEmpty) ...[
                    pw.Divider(thickness: 0.5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Recipt No : ${rn}',
                            textAlign: pw.TextAlign.start,
                            style: const pw.TextStyle(fontSize: 22.0),
                          ),
                        ]),
                    pw.SizedBox(height: 2.0),
                    pw.Table(
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromInt(0xFFFFFFFF),
                          ),
                          children: [
                            pwtitleCell(
                              'Method',
                              align: pw.TextAlign.left,
                            ),
                            pwtitleCell('Cheque No'),
                            pwtitleCell(
                              'Amount',
                              align: pw.TextAlign.right,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                            ),
                          ],
                        ),
                        if (cash != null && cash != 0)
                          pw.TableRow(
                            children: [
                              pwcell(
                                'Cash',
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                '-',
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                price(cash ?? 0),
                                align: pw.TextAlign.end,
                              ),
                            ],
                          ),
                        if ((cheques ?? dataProvider.chequeList).isNotEmpty)
                          ...(cheques ?? dataProvider.chequeList).map((m) {
                            return pw.TableRow(
                              children: [
                                pwcell(
                                  'Cheque',
                                  align: pw.TextAlign.left,
                                ),
                                pwcell(
                                  m.chequeNumber,
                                  align: pw.TextAlign.left,
                                ),
                                pwcell(
                                  price(m.chequeAmount),
                                  align: pw.TextAlign.end,
                                ),
                              ],
                            );
                          }).toList(),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total: ',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                          pwtitleCell(
                              price(double.parse(
                                  '${issuedInvoice != null ? _totalPayment() : (dataProvider.getTotalChequeAmount() + cash)}')),
                              align: pw.TextAlign.left,
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              color: PdfColor.fromInt(0xFF000000)),
                        ],
                      ),
                    )
                  ],

                  // //! Over payment or credit
                  if (balance != 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            '${balance > 0 ? 'Over Payment' : 'Credit'}',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                          pwtitleCell(
                            '${(balance > 0 ? 1 * balance : -1 * balance).toStringAsFixed(2)}',
                            align: pw.TextAlign.left,
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            color: PdfColor.fromInt(0xFF000000),
                          ),
                        ],
                      ),
                    ),

                  //! Previous payments (Credit bills)
                  if ((issuedInvoice != null
                          ? previousPayments!
                          : dataProvider.issuedInvoicePaidList)
                      .isNotEmpty) ...[
                    pw.SizedBox(height: 5.0),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Previous Payments',
                            textAlign: pw.TextAlign.start,
                            style: pw.TextStyle(
                                fontSize: 22.0, fontWeight: pw.FontWeight.bold),
                          ),
                        ]),
                    // pw.SizedBox(height: 2.0),
                    pw.SizedBox(height: 2.0),
                    pw.Table(
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(),
                          children: [
                            pwtitleCell(
                              'Date',
                              align: pw.TextAlign.left,
                            ),
                            pwtitleCell('Invoice No:'),
                            pwtitleCell(
                              'Payment',
                              align: pw.TextAlign.right,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                            ),
                          ],
                        ),
                        ...(previousPayments ??
                                dataProvider.issuedInvoicePaidList)
                            .map((dp) {
                          return pw.TableRow(
                            children: [
                              pwcell(
                                dp.issuedInvoice.createdAt ?? '-',
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                dp.issuedInvoice.invoiceNo.toString(),
                                align: pw.TextAlign.left,
                              ),
                              pwcell(
                                price(dp.paymentAmount).replaceAll('Rs.', ''),
                                align: pw.TextAlign.end,
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),
                    pw.Row(
                      children: [
                        pw.Text('Total Previous Payment',
                            style: pw.TextStyle(fontSize: 22)),
                        pw.Spacer(),
                        pw.Text(
                            price(issuedInvoice != null
                                ? previousPayments!
                                    .map((e) => e.paymentAmount)
                                    .toList()
                                    .reduce((value, element) => value + element)
                                : dataProvider.getTotalInvoicePaymentAmount()),
                            style: pw.TextStyle(fontSize: 22)),
                      ],
                    ),
                  ],

                  pw.Divider(thickness: 0.5),
                  pwtitleCell(
                    'Billing By: ${dataProvider.currentEmployee?.firstName}',
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                  pwtitleCell(
                    'Billing Date & Time: ${date(DateTime.now(), format: 'dd.MM.yyyy hh:mm a')}',
                    color: PdfColor.fromInt(0xFF000000),
                  ),
                  pw.SizedBox(height: 2),
                  MessageConstants.signatureNotRequired,
                  pw.SizedBox(height: 5)
                ],
              ),
            )
          ];
        },
      ),
    );

    return pdf.save();
  }

  _totalPayment() {
    var total = 0.0;
    for (var payment in issuedInvoice?.payments ?? []) {
      total += payment.amount;
    }
    return total;
  }

  pwcell(String value, {pw.TextAlign? align}) => pw.Padding(
        padding: const pw.EdgeInsets.all(1),
        child: pw.Text(
          value,
          textAlign: align ?? pw.TextAlign.center,
          style: const pw.TextStyle(
            fontSize: 22.0,
          ),
        ),
      );
  pwtitleCell(String value,
          {pw.TextAlign? align,
          pw.MainAxisAlignment? mainAxisAlignment = pw.MainAxisAlignment.start,
          PdfColor? color}) =>
      pw.Padding(
          padding: const pw.EdgeInsets.all(1),
          child: pw.Row(mainAxisAlignment: mainAxisAlignment!, children: [
            pw.Text(
              value,
              textAlign: align ?? pw.TextAlign.center,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 22.0,
                  color: color ?? PdfColor.fromInt(0xFF000000)),
            ),
          ]));
}
