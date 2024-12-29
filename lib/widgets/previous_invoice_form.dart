import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/issued_invoice.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class PreviousInvoiceForm extends StatefulWidget {
  final IssuedInvoice issuedInvoice;
  final TextEditingController amountController;
  final GlobalKey<FormState> formKey;
  const PreviousInvoiceForm({
    Key? key,
    required this.issuedInvoice,
    required this.amountController,
    required this.formKey,
  }) : super(key: key);

  @override
  State<PreviousInvoiceForm> createState() => _PreviousInvoiceFormState();
}

class _PreviousInvoiceFormState extends State<PreviousInvoiceForm> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              price(widget.issuedInvoice.creditValue),
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Form(
              key: widget.formKey,
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // inputFormatters: [
                //   ThousandsFormatter(
                //     allowFraction: true,
                //   ),
                // ],
                controller: widget.amountController,
                validator: (text) {
                  final chequeAmount = text!.trim().replaceAll(',', '');
                  if (chequeAmount.isEmpty) {
                    return 'Payment amount required!';
                  } else if (double.parse(chequeAmount) <= 0) {
                    return 'Invalid payment amount!';
                  } else if (double.parse(chequeAmount) >
                      widget.issuedInvoice.creditValue) {
                    return 'Maximam payment amount is ${widget.issuedInvoice.creditValue}';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                  ),
                  labelText: 'Payment amount',
                  prefixText: 'Rs. ',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
