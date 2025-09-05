// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:gsr/modules/return_cylinder/return_cylinder_view_model.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:provider/provider.dart';
// import '../../commons/common_consts.dart';
// import '../../commons/common_methods.dart';
// import '../../providers/data_provider.dart';
// import '../invoice/invoice_provider.dart';

// class PrintReturnNoteView extends StatelessWidget {
//   const PrintReturnNoteView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Print Return Note'),
//       ),
//       body: PdfPreview(
//         onPrinted: (context) async {
//           final returnCylinderViewModel = ReturnCylinderViewModel(context);
//           returnCylinderViewModel.onPressedSaveButton();
//         },
//         build: (format) => _generatePdf(format, context),
//       ),
//     );
//   }

//   Future<Uint8List> _generatePdf(
//       PdfPageFormat format, BuildContext context) async {
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//     final invoiceProvider =
//         Provider.of<InvoiceProvider>(context, listen: false);

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: ThemeConstants.pageFormat,
//         build: (context) {
//           return [
//             pw.Center(
//               child: pw.Column(
//                 children: [
//                   // Company details
//                   ...CompanyConstants.companyDetails(true),

//                   // Return Note details
//                   pw.SizedBox(height: 5.0),
//                   pw.Text(
//                     'Return Note',
//                     style: ThemeConstants.boldStyleForPdf,
//                   ),
//                   pw.SizedBox(height: 5.0),

//                   // Customer Details
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.start,
//                     children: [
//                       pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             'Return From: ${dataProvider.selectedCustomer?.businessName}',
//                             style: const pw.TextStyle(fontSize: 22.0),
//                           ),
//                           pw.Text(
//                             'Date: ${date(DateTime.now(), format: 'dd.MM.yyyy')}',
//                             style: const pw.TextStyle(fontSize: 22.0),
//                           ),
//                           pw.Text(
//                             'Return Note No: ${invoiceProvider.returnCylinderInvoiceNu}',
//                             style: const pw.TextStyle(fontSize: 22.0),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   pw.SizedBox(height: 5.0),

//                   // Items Table
//                   pw.Table(
//                     children: [
//                       pw.TableRow(
//                         decoration: const pw.BoxDecoration(
//                           color: PdfColor.fromInt(0xFFFFFFFF),
//                         ),
//                         children: [
//                           _buildTableHeaderCell('#', align: pw.TextAlign.left),
//                           _buildTableHeaderCell('Item'),
//                           _buildTableHeaderCell('Qty'),
//                           _buildTableHeaderCell('Unit Price'),
//                           _buildTableHeaderCell('Amount',
//                               align: pw.TextAlign.right),
//                         ],
//                       ),
//                       ...dataProvider.itemList.map((item) {
//                         return pw.TableRow(
//                           children: [
//                             _buildTableCell(
//                               (dataProvider.itemList.indexOf(item) + 1)
//                                   .toString(),
//                               align: pw.TextAlign.left,
//                             ),
//                             _buildTableCell(item.item.itemName,
//                                 align: pw.TextAlign.left),
//                             _buildTableCell(num(item.quantity),
//                                 align: pw.TextAlign.left),
//                             _buildTableCell(formatPrice(item.item.salePrice),
//                                 align: pw.TextAlign.left),
//                             _buildTableCell(
//                               formatPrice(item.quantity * item.item.salePrice),
//                               align: pw.TextAlign.right,
//                             ),
//                           ],
//                         );
//                       }),
//                     ],
//                   ),

//                   // Totals
//                   pw.Divider(thickness: 0.5),
//                   _buildTotalRow('Sub Total', dataProvider.getTotalAmount()),
//                   _buildTotalRow('VAT 18%', dataProvider.vat),
//                   _buildTotalRow('Grand Total', dataProvider.grandTotal),
//                   pw.Divider(thickness: 0.5),

//                   // Add Paid Invoices Table if there are any
//                   if (dataProvider.issuedInvoicePaidList.isNotEmpty) ...[
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       'Paid Invoices',
//                       style: ThemeConstants.boldStyleForPdf,
//                     ),
//                     pw.SizedBox(height: 5),
//                     pw.Table(
//                       children: [
//                         pw.TableRow(
//                           decoration: const pw.BoxDecoration(
//                             color: PdfColor.fromInt(0xFFFFFFFF),
//                           ),
//                           children: [
//                             _buildTableHeaderCell('#',
//                                 align: pw.TextAlign.left),
//                             _buildTableHeaderCell('Date'),
//                             _buildTableHeaderCell('Invoice No'),
//                             _buildTableHeaderCell('Payment',
//                                 align: pw.TextAlign.right),
//                           ],
//                         ),
//                         ...dataProvider.issuedInvoicePaidList.map((invoice) {
//                           return pw.TableRow(
//                             children: [
//                               _buildTableCell(
//                                 (dataProvider.issuedInvoicePaidList
//                                             .indexOf(invoice) +
//                                         1)
//                                     .toString(),
//                                 align: pw.TextAlign.left,
//                               ),
//                               _buildTableCell(
//                                 invoice.issuedInvoice.createdAt != null
//                                     ? date(
//                                         DateTime.parse(
//                                             invoice.issuedInvoice.createdAt!),
//                                         format: 'dd-MM-yyyy')
//                                     : '',
//                               ),
//                               _buildTableCell(invoice.issuedInvoice.invoiceNo),
//                               _buildTableCell(
//                                 formatPrice(invoice.paymentAmount),
//                                 align: pw.TextAlign.right,
//                               ),
//                             ],
//                           );
//                         }),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5),
//                     _buildTotalRow('Total Payment',
//                         dataProvider.getTotalInvoicePaymentAmount()),
//                     if (dataProvider.grandTotal >
//                         dataProvider.getTotalInvoicePaymentAmount())
//                       _buildTotalRow(
//                           'Balance',
//                           dataProvider.grandTotal -
//                               dataProvider.getTotalInvoicePaymentAmount()),
//                     pw.Divider(thickness: 0.5),
//                   ],

//                   // Footer
//                   pw.SizedBox(height: 10),
//                   _buildTableHeaderCell(
//                     'Return By: ${dataProvider.currentEmployee?.firstName}',
//                     color: const PdfColor.fromInt(0xFF000000),
//                   ),
//                   _buildTableHeaderCell(
//                     'Return Date & Time: ${date(DateTime.now(), format: 'dd.MM.yyyy hh:mm a')}',
//                     color: const PdfColor.fromInt(0xFF000000),
//                   ),
//                   pw.SizedBox(height: 2),
//                   MessageConstants.signatureNotRequired,
//                   pw.SizedBox(height: 5),
//                 ],
//               ),
//             ),
//           ];
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   pw.Widget _buildTableHeaderCell(String value,
//       {pw.TextAlign? align, PdfColor? color}) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(1),
//       child: pw.Text(
//         value,
//         textAlign: align ?? pw.TextAlign.center,
//         style: pw.TextStyle(
//           fontWeight: pw.FontWeight.bold,
//           fontSize: 22.0,
//           color: color ?? const PdfColor.fromInt(0xFF000000),
//         ),
//       ),
//     );
//   }

//   pw.Widget _buildTableCell(String value, {pw.TextAlign? align}) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(1),
//       child: pw.Text(
//         value,
//         textAlign: align ?? pw.TextAlign.center,
//         style: const pw.TextStyle(fontSize: 22.0),
//       ),
//     );
//   }

//   pw.Widget _buildTotalRow(String label, double amount) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(0),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(
//             '$label: ',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//               fontSize: 22.0,
//             ),
//           ),
//           _buildTableHeaderCell(
//             formatPrice(amount),
//             align: pw.TextAlign.right,
//             color: const PdfColor.fromInt(0xFF000000),
//           ),
//         ],
//       ),
//     );
//   }
// }
