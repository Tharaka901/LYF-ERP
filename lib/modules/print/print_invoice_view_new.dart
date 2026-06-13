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
import '../previous_customer_select/previous_screen.dart';

class _PrintInvoiceSnapshot {
  final List<AddedItem> items;
  final List<ChequeModel> cheques;
  final List<IssuedInvoicePaidModel> issuedInvoicePaidList;
  final List<IssuedDepositePaidModel> issuedDepositePaidList;
  final double subTotal;
  final double vat;
  final double nonVatItemTotal;
  final double grandTotal;
  final double totalChequeAmount;
  final double totalDepositePaymentAmount;

  const _PrintInvoiceSnapshot({
    required this.items,
    required this.cheques,
    required this.issuedInvoicePaidList,
    required this.issuedDepositePaidList,
    required this.subTotal,
    required this.vat,
    required this.nonVatItemTotal,
    required this.grandTotal,
    required this.totalChequeAmount,
    required this.totalDepositePaymentAmount,
  });

  factory _PrintInvoiceSnapshot.fromDataProvider(
    DataProvider dataProvider, {
    List<AddedItem>? itemsOverride,
    List<ChequeModel>? chequesOverride,
    List<IssuedInvoicePaidModel>? issuedInvoicePaidListOverride,
    List<IssuedDepositePaidModel>? issuedDepositePaidListOverride,
  }) {
    final items = List<AddedItem>.from(itemsOverride ?? dataProvider.itemList);
    final cheques =
        List<ChequeModel>.from(chequesOverride ?? dataProvider.chequeList);
    final issuedInvoicePaidList = List<IssuedInvoicePaidModel>.from(
      issuedInvoicePaidListOverride ?? dataProvider.issuedInvoicePaidList,
    );
    final issuedDepositePaidList = List<IssuedDepositePaidModel>.from(
      issuedDepositePaidListOverride ?? dataProvider.issuedDepositePaidList,
    );
    final subTotal = items.fold<double>(0.0, (total, addedItem) {
      final price = addedItem.item.hasSpecialPrice?.itemPrice ??
          addedItem.item.salePrice;
      return total + (price * addedItem.quantity);
    });
    final vatPercent = double.tryParse(
          dataProvider.selectedCustomer?.vat?.vatAmount ?? '0',
        ) ??
        0;
    final vat =
        double.parse(((subTotal / 100) * vatPercent).toStringAsFixed(2));
    final nonVatItemTotal = items.fold<double>(
      0,
      (sum, e) => sum + (e.item.nonVatAmount ?? 0) * e.quantity,
    );
    final grandTotal = double.parse(
      (subTotal + vat + nonVatItemTotal).toStringAsFixed(2),
    );
    final totalChequeAmount =
        cheques.fold<double>(0, (sum, c) => sum + c.chequeAmount);
    final totalDepositePaymentAmount = issuedDepositePaidList.fold<double>(
      0,
      (sum, d) => sum + d.paymentAmount,
    );

    return _PrintInvoiceSnapshot(
      items: items,
      cheques: cheques,
      issuedInvoicePaidList: issuedInvoicePaidList,
      issuedDepositePaidList: issuedDepositePaidList,
      subTotal: subTotal,
      vat: vat,
      nonVatItemTotal: nonVatItemTotal,
      grandTotal: grandTotal,
      totalChequeAmount: totalChequeAmount,
      totalDepositePaymentAmount: totalDepositePaymentAmount,
    );
  }
}

class PrintInvoiceViewNew extends StatefulWidget {
  final String invoiceNo;
  final String rn;
  final double? cash;
  final double balance;
  final InvoiceModel? issuedInvoice;
  final List<AddedItem>? items;
  final List<ChequeModel>? cheques;
  final List<IssuedInvoicePaidModel>? previousPayments;
  final List<IssuedInvoicePaidModel>? issuedInvoicePaidList;
  final List<IssuedDepositePaidModel>? issuedDepositePaidList;
  final bool? isBillingFrom;
  final Future<bool> Function()? onSaveData;
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
    this.issuedInvoicePaidList,
    this.issuedDepositePaidList,
    this.isBillingFrom,
    this.onSaveData,
    this.type,
  });

  @override
  State<PrintInvoiceViewNew> createState() => _PrintInvoiceViewNewState();
}

class _PrintInvoiceViewNewState extends State<PrintInvoiceViewNew> {
  final _viewModel = PrintInvoiceViewModel();
  _PrintInvoiceSnapshot? _snapshot;
  bool _isSaving = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if ((widget.isBillingFrom ?? false) && widget.onSaveData != null) {
      _isSaving = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _saveBeforePrint());
    } else {
      _ready = true;
    }
  }

  Future<void> _saveBeforePrint() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    _snapshot = _PrintInvoiceSnapshot.fromDataProvider(
      dataProvider,
      itemsOverride: widget.items,
      chequesOverride: widget.cheques,
      issuedInvoicePaidListOverride: widget.issuedInvoicePaidList,
      issuedDepositePaidListOverride: widget.issuedDepositePaidList,
    );

    final saved = await widget.onSaveData!();
    if (!mounted) return;

    if (!saved) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isSaving = false;
      _ready = true;
    });
  }

  Future<void> _onPrinted(BuildContext context) async {
    if (widget.type == 'previous') {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.issuedDepositePaidList.clear();
      dataProvider.chequeList.clear();
      dataProvider.issuedInvoicePaidList.clear();
      dataProvider.itemList.clear();
      if (!context.mounted) return;
      Navigator.popUntil(
        context,
        ModalRoute.withName(PreviousScreen.routeId),
      );
      return;
    }

    if (!context.mounted) return;
    _viewModel.onPrinted(context, widget.isBillingFrom ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Invoice'),
      ),
      body: _isSaving || !_ready
          ? const Center(child: CircularProgressIndicator())
          : PdfPreview(
              onPrinted: (context) async {
                await _onPrinted(context);
              },
              build: (format) => _generatePdf(format, context),
            ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, BuildContext context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final snapshot = _snapshot;
    final itemLines = widget.items ?? snapshot?.items ?? dataProvider.itemList;
    final chequesForPrint =
        widget.cheques ?? snapshot?.cheques ?? dataProvider.chequeList;
    final depositePaidList = snapshot?.issuedDepositePaidList ??
        dataProvider.issuedDepositePaidList;
    final invoicePaidList = snapshot?.issuedInvoicePaidList ??
        dataProvider.issuedInvoicePaidList;
    final totalChequeAmount =
        snapshot?.totalChequeAmount ?? dataProvider.getTotalChequeAmount();
    final totalDepositePaymentAmount = snapshot?.totalDepositePaymentAmount ??
        dataProvider.getTotalDepositePaymentAmount();

    String formatNumberNoRs(double v) {
      final s = formatPrice(v).replaceAll('Rs.', '').trim();
      return s.isEmpty ? '0.00' : s;
    }

    String formatInvoiceDate() {
      final d = widget.issuedInvoice?.routeCard?.date ??
          dataProvider.currentRouteCard?.date;
      if (d == null) return '';
      return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
    }

    // Values / labels
    final supplierVatNo =
        CompanyConstants.vatNumber.replaceAll('Our Vat No - ', '').trim();
    final supplierVatDisplay = (supplierVatNo.isEmpty || supplierVatNo == '0')
        ? 'Not Eligible'
        : supplierVatNo;
    final customer =
        widget.issuedInvoice?.customer ?? dataProvider.selectedCustomer;
    final customerVat = (customer?.customerVat?.isEmpty ?? false) ||
            (customer?.customerVat == "0")
        ? 'Not Eligible'
        : customer?.customerVat;
    final invoiceDate = formatInvoiceDate();

    final hasNewItem = itemLines.any((e) => e.item.itemTypeId == 2);
    final invoiceHeaderText = hasNewItem
        ? 'DELIVERY NOTE'
        : (customer?.isProForma == 1)
            ? 'PROFORMA INVOICE'
            : (customerVat == 'Not Eligible')
                ? 'INVOICE'
                : 'TAX INVOICE';
    final isDeliveryNote = invoiceHeaderText == 'DELIVERY NOTE';
    final vatPercent =
        double.tryParse(customer?.vat?.vatAmount ?? '18') ?? 18;
    final totalValueOfSupply = widget.issuedInvoice?.subTotal ??
        snapshot?.subTotal ??
        dataProvider.getTotalAmount();
    final vatAmount =
        widget.issuedInvoice?.vat ?? snapshot?.vat ?? dataProvider.vat;
    final nonVatItemsAmount = widget.issuedInvoice?.nonVatItemTotal ??
        snapshot?.nonVatItemTotal ??
        dataProvider.nonVatItemTotal;
    final grandTotal = widget.issuedInvoice?.amount ??
        snapshot?.grandTotal ??
        (dataProvider.getTotalAmount() + nonVatItemsAmount + vatAmount);

    double totalPaymentForPrint() {
      if ((widget.issuedInvoice?.payments ?? []).isNotEmpty) {
        return (widget.issuedInvoice!.payments ?? [])
            .fold<double>(0.0, (sum, p) => sum + (p.amount ?? 0.0));
      }
      return totalChequeAmount + (widget.cash ?? 0.0);
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
                        'Date :${invoiceDate.isEmpty ? 'MM/DD/YYYY' : invoiceDate}',
                        style: pw.TextStyle(
                          fontSize: 21,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'In No :${widget.invoiceNo}',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
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
              },
              children: [
                // Supplier row
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Supplier',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            'VAT No :$supplierVatDisplay',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
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
                  ],
                ),
                // Customer row
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Customer',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text('VAT No :${dash(customerVat)}',
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
            if (itemLines.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.3),
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
                        child: pw.Text('Amount',
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...itemLines.map((invoiceItem) {
                    final qty = invoiceItem.quantity;
                    final baseUnitPrice =
                        invoiceItem.item.hasSpecialPrice?.itemPrice ??
                            invoiceItem.item.salePrice;
                    final nonVatPerUnit = invoiceItem.item.nonVatAmount ?? 0;
                    final vatPerUnit = (baseUnitPrice / 100) * vatPercent;
                    final unitPrice = isDeliveryNote
                        ? baseUnitPrice + vatPerUnit + nonVatPerUnit
                        : baseUnitPrice;
                    final lineAmount = qty * unitPrice;
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
                          child: pw.Text(formatNumberNoRs(lineAmount),
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
                  0: const pw.FlexColumnWidth(2.0),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  if (!isDeliveryNote) ...[
                    _totalRow('Total Value of Supply',
                        formatNumberNoRs(totalValueOfSupply)),
                    _totalRow('VAT 18%', formatNumberNoRs(vatAmount)),
                    _totalRow('Nun VAT Items',
                        formatNumberNoRs(nonVatItemsAmount)),
                  ],
                  _totalRow(
                    'Total',
                    formatNumberNoRs(grandTotal),
                  ),
                ],
              ),
            ],

            // ===== Over payment settlement (Previous Deposite Payments) =====
            if (depositePaidList.isNotEmpty) ...[
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
                  ...depositePaidList.map((dp) {
                    final idx = depositePaidList.indexOf(dp) + 1;
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
                    formatPrice(totalDepositePaymentAmount),
                    fontSize: 22.0,
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
            ],

            // ===== Payment section =====
            if ((widget.issuedInvoice?.payments?.isNotEmpty ?? false) ||
                (totalChequeAmount + (widget.cash ?? 0)) != 0) ...[
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    'Recipt No : ${widget.rn}',
                    textAlign: pw.TextAlign.start,
                    style: const pw.TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              pw.SizedBox(height: 10.0),
              if ((totalChequeAmount + (widget.cash ?? 0)) != 0 ||
                  chequesForPrint.isNotEmpty)
                pw.Table(
                  border:
                      pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.0),
                    1: pw.FlexColumnWidth(1.0),
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
                    if (widget.cash != null && widget.cash != 0)
                      pw.TableRow(
                        children: [
                          _bodyCellSmall('Cash', align: pw.TextAlign.left),
                          _bodyCellSmall('-', align: pw.TextAlign.left),
                          _bodyCellSmall(
                            formatPrice(widget.cash ?? 0)
                                .replaceAll('Rs.', '')
                                .trim(),
                            align: pw.TextAlign.right,
                          ),
                        ],
                      ),
                    if (chequesForPrint.isNotEmpty)
                      ...chequesForPrint.map((m) {
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
              if ((totalChequeAmount + (widget.cash ?? 0)) != 0)
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
            if (widget.balance != 0)
              pw.Table(
                border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.5),
                  1: pw.FlexColumnWidth(1),
                },
                children: [
                  _totalRow(
                    widget.balance > 0 ? 'Over Payment' : 'Credit',
                    formatPrice(widget.balance > 0
                        ? widget.balance
                        : -1 * widget.balance),
                  ),
                ],
              ),

            // ===== Previous payments (Credit bills) =====
            ...(() {
              final prevList = widget.issuedInvoice != null
                  ? (widget.previousPayments ?? [])
                  : invoicePaidList;
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
                if (widget.balance > 0)
                  pw.Table(
                    columnWidths: const {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(1),
                    },
                    children: [
                      _totalRow(
                        'Balance:',
                        formatPrice(widget.balance),
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
            invoiceHeaderText == 'DELIVERY NOTE'
                ? pw.Text(
                    'Use for payment only.',
                    style: pw.TextStyle(fontSize: 20),
                  )
                : MessageConstants.signatureNotRequired,
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
