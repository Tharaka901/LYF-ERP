import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../commons/common_consts.dart';
import '../../commons/common_methods.dart';
import '../../models/receipt/receipt_print_model.dart';
import '../../widgets/pdf_components/basic_pdf_tile.dart';

class PrintReceiptView extends StatelessWidget {
  final ReceiptModel receiptModel;
  const PrintReceiptView({super.key, required this.receiptModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Receipt'),
        automaticallyImplyLeading: false,
      ),
      body: PdfPreview(
        onPrinted: (context) async {},
        build: (format) => _generatePdf(receiptModel),
      ),
    );
  }

  Future<Uint8List> _generatePdf(ReceiptModel receiptModel) {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(pw.MultiPage(
        pageFormat: ThemeConstants.pageFormat,
        build: (context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  //! Company details
                  ...CompanyConstants.companyDetails(true),

                  //! Receipt details
                  pw.Divider(thickness: 0.5),
                  pw.SizedBox(height: 15.0),
                  pw.Text(
                    'Receipt',
                    style: ThemeConstants.boldStyleForPdf,
                  ),
                  pw.SizedBox(height: 5.0),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Receipt No: ${receiptModel.receiptNo}',
                        style: const pw.TextStyle(
                          fontSize: 22.0,
                        ),
                      )
                    ],
                  ),

                  //!Payment methods
                  pw.SizedBox(height: 15.0),
                  pw.Table(
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
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
                      ...receiptModel.paymentMethods.map((m) {
                        return pw.TableRow(
                          children: [
                            pwcell(
                              m.name,
                              align: pw.TextAlign.left,
                            ),
                            pwcell(
                              m.chequeNu!,
                              align: pw.TextAlign.left,
                            ),
                            pwcell(
                              m.amount!,
                              align: pw.TextAlign.end,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  PdfTile.basic(
                      label: 'Total: ',
                      value: formatPrice(receiptModel.totalPayment)),
                  pw.Divider(thickness: 0.5),

                  //! Previous payments invoicess
                  pw.SizedBox(height: 15.0),
                  pw.Table(
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                        ),
                        children: [
                          pwtitleCell(
                            '#',
                            align: pw.TextAlign.left,
                          ),
                          pwtitleCell('Date'),
                          pwtitleCell('Invoice No'),
                          pwtitleCell(
                            'Payment',
                            align: pw.TextAlign.right,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                          ),
                        ],
                      ),
                      ...receiptModel.invoicess.map((i) {
                        return pw.TableRow(
                          children: [
                            pwcell(
                              (receiptModel.invoicess.indexOf(i) + 1)
                                  .toString(),
                              align: pw.TextAlign.left,
                            ),
                            pwcell(
                              i.createdAt.toString().split(' ')[0],
                              align: pw.TextAlign.left,
                            ),
                            pwcell(
                              i.invoiceNo,
                              align: pw.TextAlign.left,
                            ),
                            pwcell(
                              i.paymentAmount.toString(),
                              align: pw.TextAlign.end,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  PdfTile.basic(
                      label: 'Credit Invoice Total: ',
                      value: formatPrice(receiptModel.totalPreviousPayment)),
                  pw.Divider(thickness: 0.5),

                  //! Bottom section
                  pwtitleCell(
                    'Billing By: ${receiptModel.employee ?? '-'}',
                    color: const PdfColor.fromInt(0xFF000000),
                  ),
                  pwtitleCell(
                    'Billing Date & Time: ${receiptModel.billingDate ?? '-'}',
                    color: const PdfColor.fromInt(0xFF000000),
                  ),
                  pw.SizedBox(height: 2),
                  pw.SizedBox(height: 15.0),
                  MessageConstants.signatureNotRequired,
                ],
              ),
            )
          ];
        }));

    return pdf.save();
  }
}
