import 'package:flutter/material.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:provider/provider.dart';
import 'package:gsr/commons/common_methods.dart';

class SetCreditInvoicePaidAmountPopup extends StatefulWidget {
  const SetCreditInvoicePaidAmountPopup({super.key});

  @override
  State<SetCreditInvoicePaidAmountPopup> createState() =>
      _SetCreditInvoicePaidAmountPopupState();
}

class _SetCreditInvoicePaidAmountPopupState
    extends State<SetCreditInvoicePaidAmountPopup> {
  SelectCreditInvoiceProvider? selectCreditInvoiceProvider;
  final formKey = GlobalKey<FormState>();
  InvoiceModel? selectedCreditInvoice;

  @override
  void initState() {
    super.initState();
    selectCreditInvoiceProvider =
        Provider.of<SelectCreditInvoiceProvider>(context, listen: false);
    selectedCreditInvoice = selectCreditInvoiceProvider!.selectedCreditInvoice;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectCreditInvoiceProvider!
          .setPaidAmount(selectedCreditInvoice!.creditValue!.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  price(selectedCreditInvoice!.creditValue!),
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    // inputFormatters: [
                    //   ThousandsFormatter(
                    //     allowFraction: true,
                    //   ),
                    // ],
                    controller:
                        selectCreditInvoiceProvider!.paidAmountController,
                    validator: (text) {
                      final chequeAmount = text!.trim().replaceAll(',', '');
                      if (chequeAmount.isEmpty) {
                        return 'Payment amount required!';
                      } else if (double.parse(chequeAmount) <= 0) {
                        return 'Invalid payment amount!';
                      } else if (double.parse(chequeAmount) >
                          selectedCreditInvoice!.creditValue!) {
                        return 'Maximam payment amount is ${selectedCreditInvoice!.creditValue}';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Payment amount',
                      prefixText: 'Rs. ',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                OutlinedButton(
                  onPressed: () {
                    // if (formKey.currentState!.validate()) {
                    selectCreditInvoiceProvider!.addPaidIssuedInvoice();
                    pop(context);
                    // }
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
                    'Add',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
