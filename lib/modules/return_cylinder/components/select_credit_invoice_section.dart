import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:gsr/modules/return_cylinder/components/set_credit_invoice_paid_amount_popup.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:provider/provider.dart';

class SelectCreditInvoiceSection extends StatefulWidget {
  const SelectCreditInvoiceSection({super.key});

  @override
  State<SelectCreditInvoiceSection> createState() =>
      _SelectCreditInvoiceSectionState();
}

class _SelectCreditInvoiceSectionState
    extends State<SelectCreditInvoiceSection> {
  final invoiceFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectCreditInvoiceProvider>(
      builder: (context, selectCreditInvoiceProvider, _) =>
          selectCreditInvoiceProvider.isLoading
              ? const CircularProgressIndicator()
              : Form(
                  key: invoiceFormKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<InvoiceModel>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: selectCreditInvoiceProvider
                                    .creditInvoices.isNotEmpty
                                ? 'Select invoice'
                                : 'No previous invoices',
                          ),
                          validator: (value) {
                            if (selectCreditInvoiceProvider
                                    .selectedCreditInvoice ==
                                null) {
                              return 'Select an invoice!';
                            }
                            return null;
                          },
                          items: selectCreditInvoiceProvider
                                  .creditInvoices.isNotEmpty
                              ? selectCreditInvoiceProvider.creditInvoices
                                  .map((element) {
                                  return DropdownMenuItem(
                                    value: element,
                                    child: Text(
                                      '${element.invoiceNo}  ${formatPrice(element.creditValue ?? 0)}',
                                    ),
                                  );
                                }).toList()
                              : [],
                          onChanged: (invoice) {
                            selectCreditInvoiceProvider
                                .setSelectCreditInvoice(invoice!);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            if (invoiceFormKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const SetCreditInvoicePaidAmountPopup(),
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
                    ],
                  ),
                ),
    );
  }
}
