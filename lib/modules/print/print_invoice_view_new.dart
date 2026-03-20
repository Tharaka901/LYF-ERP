import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/cheque/cheque.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/models/issued_invoice_paid_model/issued_invoice_paid.dart';
import 'package:gsr/modules/print/print_invoice_view_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../providers/data_provider.dart';

class PrintInvoiceViewNew extends StatelessWidget {
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

  const PrintInvoiceViewNew({
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
    final viewModel = PrintInvoiceViewModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Invoice'),
      ),
      body: PdfPreview(
        onPrinted: (context) async {
          if ((isBillingFrom ?? false) & (onSaveData != null)) {
            await onSaveData!();
          }
          if (type != 'previous') {
            if (!context.mounted) return;
            viewModel.onPrinted(context, isBillingFrom ?? false);
          }
        },
        build: (format) => _generatePdf(format, context),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, BuildContext context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    String formatNumberNoRs(double v) {
      final s = formatPrice(v).replaceAll('Rs.', '').trim();
      return s.isEmpty ? '0.00' : s;
    }

    String formatInvoiceDate() {
      final d = issuedInvoice?.createdAt ?? dataProvider.currentRouteCard?.date;
      if (d == null) return '';
      return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
    }

    // Values / labels
    final supplierVatNo =
        CompanyConstants.vatNumber.replaceAll('Our Vat No - ', '').trim();
    final customer = issuedInvoice?.customer ?? dataProvider.selectedCustomer;
    final invoiceHeaderText = (customer?.isProForma == 1)
        ? 'PROFORMA INVOICE'
        : (customer?.customerVat != "0")
            ? 'TAX INVOICE'
            : 'INVOICE';

    final invoiceDate = formatInvoiceDate();
    final itemLines = items ?? dataProvider.itemList;
    final totalValueOfSupply =
        issuedInvoice?.subTotal ?? dataProvider.getTotalAmount();
    final vatAmount = issuedInvoice?.vat ?? dataProvider.vat;
    final nonVatItemsAmount =
        issuedInvoice?.nonVatItemTotal ?? dataProvider.nonVatItemTotal;
    final grandTotal = issuedInvoice?.amount ??
        (dataProvider.getTotalAmount() + nonVatItemsAmount + vatAmount);

    double totalPaymentForPrint() {
      if ((issuedInvoice?.payments ?? []).isNotEmpty) {
        return (issuedInvoice!.payments ?? [])
            .fold<double>(0.0, (sum, p) => sum + (p.amount ?? 0.0));
      }
      return dataProvider.getTotalChequeAmount() + (cash ?? 0.0);
    }

    // Template-specific supplier strings (match the screenshot wording/format).
    const supplierName = 'Jayawardena Enterprises (Pvt) Ltd';
    const supplierDistributors = 'Distributors of Litro Gas Lanka Limited';
    const supplierAddress = 'No 142,Colombo Rd,Biyagama';
    const supplierPhone = '0112 488003';

    String dash(String? v) {
      final t = v?.trim() ?? '';
      return t.isEmpty ? '------------------------------' : t;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: ThemeConstants.pageFormat,
        build: (context) {
          return [
            // ===== Top header row =====
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Center(
                    child: pw.Text(
                      invoiceHeaderText,
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Invoice Date :${invoiceDate.isEmpty ? 'MM/DD/YYYY' : invoiceDate}',
                        style: pw.TextStyle(
                          fontSize: 21,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Tax Invoice No :$invoiceNo',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== Supplier / Customer bordered box =====
            pw.SizedBox(height: 4),
            pw.Table(
              border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    // Supplier cell
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('VAT No :$supplierVatNo',
                              style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text('Name :$supplierName',
                              style: const pw.TextStyle(fontSize: 18)),
                          pw.Text(supplierDistributors,
                              style: const pw.TextStyle(fontSize: 18)),
                          pw.SizedBox(height: 2),
                          pw.Text('Address :$supplierAddress',
                              style: const pw.TextStyle(fontSize: 18)),
                          pw.SizedBox(height: 2),
                          pw.Text('Phone :$supplierPhone',
                              style: const pw.TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    // Customer cell
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('VAT No :${dash(customer?.customerVat)}',
                              style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text('Name :${dash(customer?.businessName)}',
                              style: const pw.TextStyle(fontSize: 18)),
                          pw.SizedBox(height: 2),
                          pw.Text('Address :${dash(customer?.address)}',
                              style: const pw.TextStyle(fontSize: 18)),
                          pw.SizedBox(height: 2),
                          pw.Text('Phone :${dash(customer?.contactNumber)}',
                              style: const pw.TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ===== Items table =====
            pw.SizedBox(height: 4),
            pw.Table(
              border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
              columnWidths: {
                0: const pw.FlexColumnWidth(2.7),
                1: const pw.FlexColumnWidth(0.7),
                2: const pw.FlexColumnWidth(1.0),
                3: const pw.FlexColumnWidth(2.0),
              },
              children: [
                // Header row
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      alignment: pw.Alignment.center,
                      child: pw.Text('Items',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      alignment: pw.Alignment.center,
                      child: pw.Text('Qty',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      alignment: pw.Alignment.center,
                      child: pw.Text('Unit Price',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      alignment: pw.Alignment.center,
                      child: pw.Text('Amount Excluding VAT',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                ...itemLines.map((invoiceItem) {
                  final qty = invoiceItem.quantity;
                  final unitPrice = invoiceItem.item.salePrice;
                  final amountExVat = qty * unitPrice;
                  return pw.TableRow(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(invoiceItem.item.itemName,
                            style: const pw.TextStyle(fontSize: 18)),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        child: pw.Text(num(qty).toString(),
                            style: const pw.TextStyle(fontSize: 18)),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        child: pw.Text(formatNumberNoRs(unitPrice),
                            style: const pw.TextStyle(fontSize: 18)),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(formatNumberNoRs(amountExVat),
                            style: const pw.TextStyle(fontSize: 18)),
                      ),
                    ],
                  );
                }),
              ],
            ),

            // ===== Totals bordered block (2 columns) =====
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                _totalRow('Total Value of Supply',
                    formatNumberNoRs(totalValueOfSupply)),
                _totalRow('VAT 18%', formatNumberNoRs(vatAmount)),
                _totalRow('Nun VAT Items', formatNumberNoRs(nonVatItemsAmount)),
                _totalRow(
                  'Total consideration (Including VAT)',
                  formatNumberNoRs(grandTotal),
                ),
              ],
            ),

            // ===== Over payment settlement (Previous Deposite Payments) =====
            if (dataProvider.issuedDepositePaidList.isNotEmpty) ...[
              pw.SizedBox(height: 5.0),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    'Previous Deposite Payments',
                    textAlign: pw.TextAlign.start,
                    style: pw.TextStyle(
                      fontSize: 22.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 2.0),
              pw.Table(
                border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(1.4),
                  2: pw.FlexColumnWidth(1.4),
                  3: pw.FlexColumnWidth(1.2),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _headerCellSmall('#', align: pw.TextAlign.left),
                      _headerCellSmall('Date', align: pw.TextAlign.center),
                      _headerCellSmall('Invoice No:',
                          align: pw.TextAlign.center),
                      _headerCellSmall(
                        'Payment',
                        align: pw.TextAlign.right,
                      ),
                    ],
                  ),
                  ...dataProvider.issuedDepositePaidList.map((dp) {
                    final idx =
                        dataProvider.issuedDepositePaidList.indexOf(dp) + 1;
                    final dateStr = date(
                      dp.issuedDeposite.routeCard?.date ?? DateTime.now(),
                      format: 'dd-MM-yyyy',
                    );
                    final amountStr = formatPrice(dp.paymentAmount)
                        .replaceAll('Rs.', '')
                        .trim();
                    return pw.TableRow(
                      children: [
                        _bodyCellSmall(idx.toString(),
                            align: pw.TextAlign.left),
                        _bodyCellSmall(dateStr, align: pw.TextAlign.center),
                        _bodyCellSmall(
                          dp.issuedDeposite.receiptNo ?? '-',
                          align: pw.TextAlign.center,
                        ),
                        _bodyCellSmall(amountStr, align: pw.TextAlign.right),
                      ],
                    );
                  }),
                ],
              ),
              pw.Divider(thickness: 0.5),
              pw.Table(
                columnWidths: const {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(1),
                },
                children: [
                  _totalRow(
                    'Total Previous Deposite Payment',
                    formatPrice(dataProvider.getTotalDepositePaymentAmount()),
                    fontSize: 22.0,
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
            ],

            // ===== Payment section =====
            if ((issuedInvoice?.payments?.isNotEmpty ?? false) ||
                (dataProvider.getTotalChequeAmount() + (cash ?? 0)) != 0) ...[
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    'Recipt No : $rn',
                    textAlign: pw.TextAlign.start,
                    style: const pw.TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              pw.SizedBox(height: 10.0),
              if ((dataProvider.getTotalChequeAmount() + (cash ?? 0)) != 0)
                pw.Table(
                  border:
                      pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.1),
                    1: pw.FlexColumnWidth(1.2),
                    2: pw.FlexColumnWidth(1.0),
                  },
                  children: [
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        _headerCellSmall('Method', align: pw.TextAlign.left),
                        _headerCellSmall('Cheque No',
                            align: pw.TextAlign.center),
                        _headerCellSmall(
                          'Amount',
                          align: pw.TextAlign.right,
                        ),
                      ],
                    ),
                    if (cash != null && cash != 0)
                      pw.TableRow(
                        children: [
                          _bodyCellSmall('Cash', align: pw.TextAlign.left),
                          _bodyCellSmall('-', align: pw.TextAlign.left),
                          _bodyCellSmall(
                            formatPrice(cash ?? 0).replaceAll('Rs.', '').trim(),
                            align: pw.TextAlign.right,
                          ),
                        ],
                      ),
                    if ((cheques ?? dataProvider.chequeList).isNotEmpty)
                      ...(cheques ?? dataProvider.chequeList).map((m) {
                        final amountStr = formatPrice(m.chequeAmount)
                            .replaceAll('Rs.', '')
                            .trim();
                        return pw.TableRow(
                          children: [
                            _bodyCellSmall('Cheque', align: pw.TextAlign.left),
                            _bodyCellSmall(
                              m.chequeNumber,
                              align: pw.TextAlign.left,
                            ),
                            _bodyCellSmall(amountStr,
                                align: pw.TextAlign.right),
                          ],
                        );
                      }),
                  ],
                ),
              if ((dataProvider.getTotalChequeAmount() + (cash ?? 0)) != 0)
                pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: [
                    _totalRow('Total:', formatPrice(totalPaymentForPrint())),
                  ],
                ),
            ],

            // ===== Over payment or credit =====
            if (balance != 0)
              pw.Table(
                border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.5),
                  1: pw.FlexColumnWidth(1),
                },
                children: [
                  _totalRow(
                    balance > 0 ? 'Over Payment' : 'Credit',
                    formatPrice(balance > 0 ? balance : -1 * balance),
                  ),
                ],
              ),

            // ===== Previous payments (Credit bills) =====
            ...(() {
              final prevList = issuedInvoice != null
                  ? (previousPayments ?? [])
                  : dataProvider.issuedInvoicePaidList;
              if (prevList.isEmpty) return <pw.Widget>[];

              final prevTotal = prevList
                  .map((e) => e.paymentAmount)
                  .fold<double>(0.0, (a, b) => a + b);

              return [
                pw.SizedBox(height: 5.0),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Previous Payments',
                      textAlign: pw.TextAlign.start,
                      style: pw.TextStyle(
                        fontSize: 22.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2.0),
                pw.Table(
                  border:
                      pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.6),
                    1: pw.FlexColumnWidth(1.4),
                    2: pw.FlexColumnWidth(1.2),
                  },
                  children: [
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        _headerCellSmall('Date', align: pw.TextAlign.left),
                        _headerCellSmall('Invoice No:',
                            align: pw.TextAlign.center),
                        _headerCellSmall('Payment', align: pw.TextAlign.right),
                      ],
                    ),
                    ...prevList.map((dp) {
                      final dateStr = dp.issuedInvoice.routeCard?.date
                              ?.toString()
                              .split(' ')[0] ??
                          'No Date';
                      final amountStr = formatPrice(dp.paymentAmount)
                          .replaceAll('Rs.', '')
                          .trim();
                      return pw.TableRow(
                        children: [
                          _bodyCellSmall(dateStr, align: pw.TextAlign.left),
                          _bodyCellSmall(
                            dp.issuedInvoice.invoiceNo.toString(),
                            align: pw.TextAlign.left,
                          ),
                          _bodyCellSmall(amountStr, align: pw.TextAlign.right),
                        ],
                      );
                    }),
                  ],
                ),
                pw.Divider(thickness: 0.5),
                pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: [
                    _totalRow(
                      'Total Previous Payment',
                      formatPrice(prevTotal),
                      fontSize: 22.0,
                    ),
                  ],
                ),
                if (balance > 0)
                  pw.Table(
                    columnWidths: const {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(1),
                    },
                    children: [
                      _totalRow(
                        'Balance:',
                        formatPrice(balance),
                        fontSize: 22.0,
                      ),
                    ],
                  ),
              ];
            }()),

            // ===== Footer signature lines =====
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 0.5),
            pwtitleCell(
              'Billing By: ${dataProvider.currentEmployee?.firstName}',
              color: const PdfColor.fromInt(0xFF000000),
            ),
            pwtitleCell(
              'Billing Date & Time: ${date(DateTime.now(), format: 'dd.MM.yyyy hh:mm a')}',
              color: const PdfColor.fromInt(0xFF000000),
            ),
            pw.SizedBox(height: 2),
            MessageConstants.signatureNotRequired,
            pw.SizedBox(height: 5)
            // pw.Row(
            //   children: [
            //     pw.Expanded(
            //       child: pw.Column(
            //         crossAxisAlignment: pw.CrossAxisAlignment.start,
            //         children: [
            //           pw.Container(
            //             alignment: pw.Alignment.centerLeft,
            //             child: pw.Text(
            //               '..........................................................',
            //               style: const pw.TextStyle(fontSize: 10),
            //             ),
            //           ),
            //           pw.SizedBox(height: 2),
            //           pw.Text('Prepare by',
            //               style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.bold, fontSize: 12)),
            //         ],
            //       ),
            //     ),
            //     pw.Expanded(
            //       child: pw.Column(
            //         crossAxisAlignment: pw.CrossAxisAlignment.end,
            //         children: [
            //           pw.Container(
            //             alignment: pw.Alignment.centerRight,
            //             child: pw.Text(
            //               '..........................................................',
            //               style: const pw.TextStyle(fontSize: 10),
            //             ),
            //           ),
            //           pw.SizedBox(height: 2),
            //           pw.Text('Customer Signature',
            //               style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.bold, fontSize: 12)),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}

pw.TableRow _totalRow(
  String label,
  String value, {
  double fontSize = 22.0,
  double valueFontSize = 22.0,
}) {
  return pw.TableRow(
    children: [
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
          label,
          style:
              pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          value,
          style: pw.TextStyle(fontSize: valueFontSize),
        ),
      ),
    ],
  );
}

pw.Widget _headerCellSmall(
  String text, {
  pw.TextAlign align = pw.TextAlign.center,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
    ),
  );
}

pw.Widget _bodyCellSmall(
  String text, {
  pw.TextAlign align = pw.TextAlign.center,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    child: pw.Text(
      text,
      textAlign: align,
      style: const pw.TextStyle(fontSize: 20),
    ),
  );
}
