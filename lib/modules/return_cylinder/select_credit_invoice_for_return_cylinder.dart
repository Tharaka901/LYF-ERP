import 'package:flutter/material.dart';
import 'package:gsr/models/issued_invoice_paid_model/issued_invoice_paid.dart';
import 'package:provider/provider.dart';
import '../../commons/common_methods.dart';
import '../../models/invoice/invoice_model.dart';
import '../../providers/data_provider.dart';
import '../../services/database.dart';
import '../../widgets/previous_invoice_form.dart';
import '../../widgets/tiles/basic_tile.dart';
import 'return_cylinder_view_model.dart';

class SelectCreditInvoiceForReturnCylinderScreen extends StatefulWidget {
  const SelectCreditInvoiceForReturnCylinderScreen({super.key});

  @override
  State<SelectCreditInvoiceForReturnCylinderScreen> createState() =>
      _SelectCreditInvoiceForReturnCylinderScreenState();
}

class _SelectCreditInvoiceForReturnCylinderScreenState
    extends State<SelectCreditInvoiceForReturnCylinderScreen> {
  final invoiceFormKey = GlobalKey<FormState>();
  ReturnCylinderViewModel? returnCylinderViewModel;

  @override
  void initState() {
    super.initState();
    returnCylinderViewModel = ReturnCylinderViewModel(context);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Invoice'),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              BasicTile(
                  label: 'Total Return Cylinder Price',
                  value: formatPrice(dataProvider.grandTotal)),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<InvoiceModel>>(
                future: creditInvoices(context,
                    cId: selectedCustomer!.customerId, type: 'with-cheque'),
                builder: (context, AsyncSnapshot<List<InvoiceModel>> snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: Form(
                            key: invoiceFormKey,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: DropdownButtonFormField<InvoiceModel>(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      labelText: snapshot.connectionState ==
                                              ConnectionState.waiting
                                          ? 'Loading...'
                                          : (snapshot.hasData &&
                                                  snapshot.data!.isNotEmpty
                                              ? 'Select invoice'
                                              : 'No previous invoices'),
                                    ),
                                    validator: (value) {
                                      if (dataProvider.selectedInvoice ==
                                          null) {
                                        return 'Select an invoice!';
                                      } else if (dataProvider
                                          .issuedInvoicePaidList
                                          .where((element) =>
                                              element.issuedInvoice.invoiceId ==
                                              dataProvider
                                                  .selectedInvoice!.invoiceId)
                                          .isNotEmpty) {
                                        return 'Already added!';
                                      }
                                      return null;
                                    },
                                    items: snapshot.hasData
                                        ? snapshot.data!.map((element) {
                                            return DropdownMenuItem(
                                              value: element,
                                              child: Text(
                                                '${element.invoiceNo}  ${element.creditValue != null ? formatPrice(element.creditValue!) : ''}',
                                              ),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (invoice) {
                                      dataProvider.setSelectedInvoice(invoice);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Consumer<DataProvider>(
                                    builder: (context, data, _) => IconButton(
                                      onPressed: () {
                                        if (invoiceFormKey.currentState!
                                            .validate()) {
                                          final amountController =
                                              TextEditingController(
                                                  text: data.selectedInvoice!
                                                              .creditValue !=
                                                          null
                                                      ? data.selectedInvoice!
                                                          .creditValue!
                                                          .toString()
                                                      : '');
                                          final formKey =
                                              GlobalKey<FormState>();

                                          confirm(
                                            context,
                                            title:
                                                data.selectedInvoice!.invoiceNo,
                                            body: PreviousInvoiceForm(
                                              issuedInvoice:
                                                  data.selectedInvoice!,
                                              amountController:
                                                  amountController,
                                              formKey: formKey,
                                            ),
                                            confirmText: 'Add',
                                            onConfirm: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                data.addPaidIssuedInvoice(
                                                  IssuedInvoicePaidModel(
                                                    chequeId: dataProvider
                                                        .selectedInvoice!
                                                        .chequeId,
                                                    creditAmount: data
                                                        .selectedInvoice!
                                                        .creditValue,
                                                    issuedInvoice:
                                                        data.selectedInvoice!,
                                                    paymentAmount: doub(
                                                        amountController.text
                                                            .replaceAll(
                                                                ',', '')),
                                                  ),
                                                );
                                                data.setSelectedInvoice(null);
                                                pop(context);
                                                return;
                                              }
                                            },
                                          );
                                          return;
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
              ),
              const SizedBox(height: 15),
              Consumer<DataProvider>(
                  builder: (context, data, _) => data
                          .issuedInvoicePaidList.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Table(
                                defaultColumnWidth:
                                    const IntrinsicColumnWidth(),
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    children: [
                                      titleCell(
                                        '#',
                                        align: TextAlign.start,
                                      ),
                                      titleCell(
                                        'Date',
                                        align: TextAlign.center,
                                      ),
                                      titleCell(
                                        'Invoice No:',
                                        align: TextAlign.center,
                                      ),
                                      titleCell(
                                        'Payment',
                                        align: TextAlign.center,
                                      ),
                                      titleCell(
                                        'X',
                                        align: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  ...data.issuedInvoicePaidList.map(
                                    (invoice) => TableRow(
                                      children: [
                                        cell(
                                          (data.issuedInvoicePaidList
                                                      .indexOf(invoice) +
                                                  1)
                                              .toString(),
                                          align: TextAlign.start,
                                        ),
                                        cell(
                                          invoice.issuedInvoice.createdAt !=
                                                  null
                                              ? date(
                                                  DateTime.parse(invoice
                                                      .issuedInvoice
                                                      .createdAt!),
                                                  format: 'dd-MM-yyyy')
                                              : '',
                                          align: TextAlign.center,
                                        ),
                                        cell(invoice.issuedInvoice.invoiceNo),
                                        cell(
                                          formatPrice(invoice.paymentAmount)
                                              .replaceAll('Rs.', ''),
                                          align: TextAlign.center,
                                        ),
                                        InkWell(
                                          onTap: () => data
                                              .removePaidIssuedInvoice(invoice),
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
                            const Divider(
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                text('Total Payment'),
                                const Spacer(),
                                text(formatPrice(
                                    data.getTotalInvoicePaymentAmount())),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                      : dummy),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      onPressed: returnCylinderViewModel!.onPressedSaveButton,
                      text: 'Save',
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      onPressed: returnCylinderViewModel!.onPressedPrintButton,
                      text: 'Print',
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String text,
    Color? color,
  }) {
    return SizedBox(
      height: 55.0,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

TableCell cell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
        ),
      ),
    );
TableCell titleCell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
Widget text(String value, {TextAlign? align}) => Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        value,
        textAlign: align ?? TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
