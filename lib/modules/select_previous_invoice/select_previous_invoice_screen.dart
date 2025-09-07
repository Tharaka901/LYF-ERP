import 'package:flutter/material.dart';
import 'package:gsr/modules/previous_add_payment/previous_add_payment_screen.dart';
import 'package:provider/provider.dart';

import '../../commons/common_consts.dart';
import '../../commons/common_methods.dart';
import '../../models/invoice/invoice_model.dart';
import '../../models/issued_invoice_paid_model/issued_invoice_paid.dart';
import '../../providers/data_provider.dart';
import '../../widgets/popups/customer_deposite_paid_for_prevoius_invoice.dart';
import '../../widgets/previous_invoice_form.dart';
import '../view_receipt/invoice_receipt_view_model.dart';
import 'select_previous_invoice_view_model.dart';

class SelectPreviousInvoiceScreen extends StatefulWidget {
  final bool? isDirectPrevoius;
  final String? overPaymentAmount;
  const SelectPreviousInvoiceScreen({
    super.key,
    this.isDirectPrevoius = true,
    this.overPaymentAmount = '0',
  });

  @override
  State<SelectPreviousInvoiceScreen> createState() =>
      _SelectPreviousInvoiceScreenState();
}

class _SelectPreviousInvoiceScreenState
    extends State<SelectPreviousInvoiceScreen> {
  final selectPreviousInvoiceViewModel = SelectPreviousInvoiceViewModel();
  final invoiceReceiptViewModel = InvoiceReceiptViewModel();

  final TextEditingController paymentController = TextEditingController();
  final GlobalKey<FormState> depositeFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer;

    if (selectedCustomer == null) {
      return const Scaffold(
        body: Center(child: Text('Select customer')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Select Invoice')),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _CustomerHeader(selectedCustomer.businessName!),
            if (!widget.isDirectPrevoius!) ...[
              _OverPaymentRow(widget.overPaymentAmount),
              const SizedBox(height: 15),
            ],
            _InvoiceDropdown(
              invoiceReceiptViewModel: invoiceReceiptViewModel,
              selectPreviousInvoiceViewModel: selectPreviousInvoiceViewModel,
              dataProvider: dataProvider,
            ),
            const SizedBox(height: 15),
            _OverPaymentSettleButton(
              paymentController: paymentController,
              formKey: depositeFormKey,
              selectPreviousInvoiceViewModel: selectPreviousInvoiceViewModel,
            ),
            const SizedBox(height: 15),
            Consumer<DataProvider>(
              builder: (context, data, _) =>
                  data.issuedInvoicePaidList.isNotEmpty
                      ? _InvoicePaidTable()
                      : dummy,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Extracted Widgets ---

class _CustomerHeader extends StatelessWidget {
  final String businessName;
  const _CustomerHeader(this.businessName);

  @override
  Widget build(BuildContext context) {
    return Text(
      businessName,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
    );
  }
}

class _OverPaymentRow extends StatelessWidget {
  final String? overPaymentAmount;
  const _OverPaymentRow(this.overPaymentAmount);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Text(
            'Over payment:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.green[700]),
          ),
          const Spacer(),
          Text(
            overPaymentAmount ?? '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.green[700]),
          ),
        ],
      ),
    );
  }
}

class _InvoiceDropdown extends StatelessWidget {
  final InvoiceReceiptViewModel invoiceReceiptViewModel;
  final SelectPreviousInvoiceViewModel selectPreviousInvoiceViewModel;
  final DataProvider dataProvider;

  const _InvoiceDropdown({
    required this.invoiceReceiptViewModel,
    required this.selectPreviousInvoiceViewModel,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InvoiceModel>>(
      future: invoiceReceiptViewModel.getCreditInvoices(
        context,
        cId: dataProvider.selectedCustomer!.customerId,
        type: 'with-cheque',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return SizedBox(
          width: double.infinity,
          child: Form(
            key: selectPreviousInvoiceViewModel.invoiceFormKey,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<InvoiceModel>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: snapshot.hasData && snapshot.data!.isNotEmpty
                          ? 'Select invoice'
                          : 'No previous invoices',
                    ),
                    validator: (value) {
                      if (dataProvider.selectedInvoice == null) {
                        return 'Select an invoice!';
                      } else if (dataProvider.issuedInvoicePaidList.any(
                          (element) =>
                              element.issuedInvoice.invoiceNo ==
                              dataProvider.selectedInvoice!.invoiceNo)) {
                        return 'Already added!';
                      }
                      return null;
                    },
                    items: snapshot.hasData
                        ? snapshot.data!.map((element) {
                            return DropdownMenuItem(
                              value: element,
                              child: Text(
                                  '${element.invoiceNo}  ${price(element.creditValue!)}'),
                            );
                          }).toList()
                        : [],
                    onChanged: (invoice) {
                      dataProvider.setSelectedInvoice(invoice);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Consumer<DataProvider>(
                    builder: (context, data, _) => IconButton(
                      onPressed: () {
                        if (selectPreviousInvoiceViewModel
                            .invoiceFormKey.currentState!
                            .validate()) {
                          final amountController = TextEditingController(
                              text: num(data.selectedInvoice!.creditValue!)
                                  .toString());
                          final formKey = GlobalKey<FormState>();

                          confirm(
                            context,
                            title: data.selectedInvoice!.invoiceNo,
                            body: PreviousInvoiceForm(
                              issuedInvoice: data.selectedInvoice!,
                              amountController: amountController,
                              formKey: formKey,
                            ),
                            confirmText: 'Add',
                            onConfirm: () {
                              if (formKey.currentState!.validate()) {
                                data.addPaidIssuedInvoice(
                                  IssuedInvoicePaidModel(
                                    chequeId:
                                        dataProvider.selectedInvoice!.chequeId,
                                    creditAmount:
                                        data.selectedInvoice!.creditValue,
                                    issuedInvoice: data.selectedInvoice!,
                                    paymentAmount: doub(amountController.text
                                        .replaceAll(',', '')),
                                    invoiceId: data.selectedInvoice?.invoiceId
                                  ),
                                );
                                data.setSelectedInvoice(null);
                                pop(context);
                              }
                            },
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OverPaymentSettleButton extends StatelessWidget {
  final TextEditingController paymentController;
  final GlobalKey<FormState> formKey;
  final SelectPreviousInvoiceViewModel selectPreviousInvoiceViewModel;

  const _OverPaymentSettleButton({
    required this.paymentController,
    required this.formKey,
    required this.selectPreviousInvoiceViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.0,
      child: OutlinedButton(
        onPressed: () {
          confirm(
            context,
            title: 'Over Payment Invoices',
            body: CustomerDepositePaidForPriviousInvoice(
              paymentController: paymentController,
              formKey: formKey,
              callBack: (selectedBalance) {},
            ),
            onConfirm: () async {
              if (formKey.currentState!.validate()) {
                waiting(context, body: 'Sending...');
                try {
                  selectPreviousInvoiceViewModel.payFromDeposite(
                      context, paymentController);
                } catch (e) {
                  print(e.toString());
                }
              }
            },
            confirmText: 'Add',
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blue[800]),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: const Text(
          'Over Payment Settle',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }
}

class _InvoicePaidTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);

    return Column(
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
                  titleCell('#', align: TextAlign.start),
                  titleCell('Date', align: TextAlign.center),
                  titleCell('Invoice No:', align: TextAlign.center),
                  titleCell('Payment', align: TextAlign.center),
                  titleCell('X', align: TextAlign.center),
                ],
              ),
              ...data.issuedInvoicePaidList.map(
                (invoice) => TableRow(
                  children: [
                    cell(
                      (data.issuedInvoicePaidList.indexOf(invoice) + 1)
                          .toString(),
                      align: TextAlign.start,
                    ),
                    cell(
                      invoice.issuedInvoice.routeCard?.date?.toString().split(' ')[0] ?? 'No Date',
                      align: TextAlign.center,
                    ),
                    cell(invoice.issuedInvoice.invoiceNo),
                    cell(
                      price(invoice.paymentAmount).replaceAll('Rs.', ''),
                      align: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () => data.removePaidIssuedInvoice(invoice),
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
        const Divider(color: Colors.black),
        Row(
          children: [
            text('Total Payment'),
            const Spacer(),
            text(price(data.getTotalInvoicePaymentAmount())),
          ],
        ),
        const Divider(color: Colors.black),
        const SizedBox(height: 10),
        Consumer<DataProvider>(
          builder: (context, data, _) {
            return data.issuedDepositePaidList.isNotEmpty
                ? _DepositePaidTable()
                : const SizedBox();
          },
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 55.0,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PreviousAddPaymentScreen(),
              ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue[800]),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: const Text(
              'Pay',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _DepositePaidTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);

    return Column(
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
                  titleCell('#', align: TextAlign.start),
                  titleCell('Date', align: TextAlign.center),
                  titleCell('Invoice No:', align: TextAlign.center),
                  titleCell('Payment', align: TextAlign.center),
                  titleCell('X', align: TextAlign.center),
                ],
              ),
              ...data.issuedDepositePaidList.map(
                (invoice) => TableRow(
                  children: [
                    cell(
                      (data.issuedDepositePaidList.indexOf(invoice) + 1)
                          .toString(),
                      align: TextAlign.start,
                    ),
                    cell(
                      date(invoice.issuedDeposite.createdAt!,
                          format: 'dd-MM-yyyy'),
                      align: TextAlign.center,
                    ),
                    cell(invoice.issuedDeposite.paymentInvoiceId.toString()),
                    cell(
                      price(invoice.paymentAmount).replaceAll('Rs.', ''),
                      align: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () => data.removePaidDepositeInvoice(invoice),
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
        const Divider(color: Colors.black),
        Row(
          children: [
            text('Total Over Payment'),
            const Spacer(),
            text(price(data.getTotalDepositePaymentAmount())),
          ],
        ),
        const Divider(color: Colors.black),
      ],
    );
  }
}
