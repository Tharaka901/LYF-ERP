import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/balance.dart';
import 'package:gsr/models/issued_invoice.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

import '../models/issued_invoice_paid.dart';

class CreditInvoice extends StatefulWidget {
  final TextEditingController paymentController;
  final GlobalKey<FormState> formKey;
  final double balance;
  final int? invoiceId;
  final void Function(Balance selectedBalance) callBack;
  const CreditInvoice({
    Key? key,
    required this.paymentController,
    required this.formKey,
    required this.callBack,
    required this.balance,
    this.invoiceId,
  }) : super(key: key);

  @override
  State<CreditInvoice> createState() => _CreditInvoiceState();
}

class _CreditInvoiceState extends State<CreditInvoice> {
  final quantityFocus = FocusNode();
  var selectedBalance = 0.0;
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<IssuedInvoice>>(
              future: creditInvoices(
                context,
                cId: dataProvider.selectedCustomer!.customerId,
                type: 'with-cheque',
                invoiceId: widget.invoiceId,
              ),
              builder: (context, AsyncSnapshot<List<IssuedInvoice>> snapshot) {
                return DropdownButtonFormField<IssuedInvoice>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText:
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading...'
                            : (snapshot.hasData && snapshot.data!.isNotEmpty
                                ? 'Select invoice'
                                : 'No invoices'),
                  ),
                  value: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data![0]
                      : null,
                  items: snapshot.hasData
                      ? snapshot.data!.map((element) {
                          return DropdownMenuItem(
                            value: element,
                            child: Text(
                              '${element.invoiceNo}  ${price(element.creditValue)}',
                            ),
                          );
                        }).toList()
                      : [],
                  onChanged: (invoice) {
                    dataProvider.setSelectedInvoice(invoice);
                  },
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Consumer<DataProvider>(
              builder: (context, data, _) => TextFormField(
                controller: widget.paymentController,
                focusNode: quantityFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Payment',
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Payment cannot be empty!';
                  } else if (doub(text) <= 0) {
                    return 'Invalid payment!';
                  } else if (doub(text) >
                      dataProvider.selectedInvoice?.creditValue) {
                    return 'Maximam payment amount is ${dataProvider.selectedInvoice?.creditValue}';
                  } else if (doub(text) >
                      double.parse(
                          (widget.balance - data.getTotalCreditPaymentAmount())
                              .toStringAsFixed(2))) {
                    return 'Maximum ${price(widget.balance - data.getTotalCreditPaymentAmount())}';
                  }
                  data.addPaidIssuedInvoice(
                    IssuedInvoicePaid(
                      creditAmount: data.selectedInvoice!.creditValue,
                      issuedInvoice: data.selectedInvoice!,
                      chequeId: data.selectedInvoice?.chequeId,
                      paymentAmount: doub(
                          widget.paymentController.text.replaceAll(',', '')),
                    ),
                  );
                  data.setSelectedInvoice(null);
                  pop(context);
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
