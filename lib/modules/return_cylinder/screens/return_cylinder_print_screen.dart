import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/providers/return_cylinder_provider.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/widgets/pdf_components/pdf_summary_row.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ReturnCylinderPrintScreen extends StatelessWidget {
  const ReturnCylinderPrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Return Cylinder'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        onPrinted: (context) {
          // Save data after printing
          final returnCylinderProvider =
              Provider.of<ReturnCylinderProvider>(context, listen: false);
          returnCylinderProvider.saveReturnCylinderData(context);
          Navigator.of(context).pop();
        },
        build: (format) => _generatePdf(format, context),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, BuildContext context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final returnCylinderProvider =
        Provider.of<ReturnCylinderProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectCreditInvoiceProvider =
        Provider.of<SelectCreditInvoiceProvider>(context, listen: false);

    // Get data from providers
    final invoiceNo = returnCylinderProvider.returnCylinderInvoiceNumber;
    final totalAmount = returnCylinderProvider.grandPrice;
    final vatAmount = returnCylinderProvider.vatAmount;
    final nonVatAmount = returnCylinderProvider.nonVatAmount;
    final totalItemAmount = returnCylinderProvider.totalItemAmount;
    final items = returnCylinderProvider.selectedItems;
    final paidIssuedInvoices = selectCreditInvoiceProvider.paidIssuedInvoices;
    final totalInvoicePaymentAmount =
        selectCreditInvoiceProvider.totalInvoicePaymentAmount;
    final customerName = dataProvider.selectedCustomer?.businessName ?? '';
    final customerVat = dataProvider.selectedCustomer?.customerVat ?? '';
    final date =
        dataProvider.currentRouteCard?.date?.toString().split(' ')[0] ?? '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: ThemeConstants.pageFormat,
        build: (context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  // Company details
                  ...CompanyConstants.companyDetails(true),

                  // Return Cylinder Invoice details
                  pw.SizedBox(height: 10.0),
                  pw.Text(
                    'Tax Return Note',
                    style: ThemeConstants.boldStyleForPdf,
                  ),
                  pw.SizedBox(height: 5.0),

                  // Invoice and receipt details
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Return From: $customerName',
                            style: const pw.TextStyle(fontSize: 22.0),
                          ),
                          pw.Text(
                            'Date: $date',
                            style: const pw.TextStyle(fontSize: 22.0),
                          ),
                          pw.Text(
                            'Customer VAT No: $customerVat',
                            style: const pw.TextStyle(fontSize: 22.0),
                          ),
                          pw.Text(
                            'Return Note No: $invoiceNo',
                            style: const pw.TextStyle(fontSize: 22.0),
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 10.0),

                  //! Items table header
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(8.0),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            'Item',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Qty',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Unit Price',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Total',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Items table body
                  ...items.map((item) => pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(8.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.grey),
                          ),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                item.itemName,
                                style: const pw.TextStyle(fontSize: 12.0),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                '${item.itemQty ?? 0}',
                                style: const pw.TextStyle(fontSize: 12.0),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                price(item.salePrice),
                                style: const pw.TextStyle(fontSize: 12.0),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                price((item.salePrice * (item.itemQty ?? 0))),
                                style: const pw.TextStyle(fontSize: 12.0),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),

                  pw.SizedBox(height: 15.0),

                  //! Summary section
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10.0),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey),
                    ),
                    child: pw.Column(
                      children: [
                        PdfSummaryRow.create(
                            label: 'Sub Total:', value: price(totalItemAmount)),
                        pw.SizedBox(height: 5.0),
                        PdfSummaryRow.create(
                            label: 'VAT (18%):', value: price(vatAmount)),
                        pw.SizedBox(height: 5.0),
                        PdfSummaryRow.create(
                            label: 'Non VAT Item Total  :',
                            value: price(nonVatAmount)),
                        pw.SizedBox(height: 5.0),
                        PdfSummaryRow.create(
                            label: 'Grand Total:', value: price(totalAmount)),
                        pw.SizedBox(height: 5.0),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20.0),

                  //! Paid Issued Invoices section
                  if (paidIssuedInvoices.isNotEmpty) ...[
                    pw.SizedBox(height: 10.0),

                    // Paid Invoices Table Header
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(8.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'Invoice No',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'Date',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'Credit',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'Payment',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //! Paid Invoices Table Body
                    ...paidIssuedInvoices.map((paidInvoice) => pw.Container(
                          width: double.infinity,
                          padding: const pw.EdgeInsets.all(8.0),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(color: PdfColors.grey),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  paidInvoice.issuedInvoice.invoiceNo,
                                  style: const pw.TextStyle(fontSize: 12.0),
                                ),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  paidInvoice.issuedInvoice.createdAt
                                          ?.toString()
                                          .split(' ')[0] ??
                                      '',
                                  style: const pw.TextStyle(fontSize: 12.0),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  price(paidInvoice.creditAmount ?? 0),
                                  style: const pw.TextStyle(fontSize: 12.0),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  price(paidInvoice.paymentAmount),
                                  style: const pw.TextStyle(fontSize: 12.0),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )),

                    //! Total Payment Amount Row
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(10.0),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                      ),
                      child: pw.Column(
                        children: [
                          PdfSummaryRow.create(
                              label: 'Total Payment Amount:',
                              value: price(totalInvoicePaymentAmount)),
                          pw.SizedBox(height: 5.0),
                          PdfSummaryRow.create(
                              label: 'Balance Amount:',
                              value: price(
                                  totalAmount - totalInvoicePaymentAmount)),
                          pw.SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ],

                  pw.SizedBox(height: 10.0),

                  // Footer
                  pw.Divider(thickness: 0.5),
                  pwtitleCell(
                    'Billing By: ${dataProvider.currentEmployee?.firstName}',
                    color: const PdfColor.fromInt(0xFF000000),
                  ),
                  pwtitleCell(
                    'Billing Date & Time: $date',
                    color: const PdfColor.fromInt(0xFF000000),
                  ),
                  pw.SizedBox(height: 2),
                  MessageConstants.signatureNotRequired,
                  pw.SizedBox(height: 5)
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
