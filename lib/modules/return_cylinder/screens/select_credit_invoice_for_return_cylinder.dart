import 'package:flutter/material.dart';
import 'package:gsr/modules/return_cylinder/providers/select_credit_invoice_provider.dart';
import 'package:gsr/modules/return_cylinder/components/select_credit_invoice_section.dart';
import 'package:gsr/modules/return_cylinder/components/credit_invoice_paid_table.dart';
import 'package:gsr/modules/return_cylinder/providers/return_cylinder_provider.dart';
import 'package:provider/provider.dart';
import '../../../commons/common_methods.dart';
import '../../../providers/data_provider.dart';

class SelectCreditInvoiceForReturnCylinderScreen extends StatefulWidget {
  const SelectCreditInvoiceForReturnCylinderScreen({super.key});

  @override
  State<SelectCreditInvoiceForReturnCylinderScreen> createState() =>
      _SelectCreditInvoiceForReturnCylinderScreenState();
}

class _SelectCreditInvoiceForReturnCylinderScreenState
    extends State<SelectCreditInvoiceForReturnCylinderScreen> {
  final invoiceFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectCreditInvoiceProvider =
          Provider.of<SelectCreditInvoiceProvider>(context, listen: false);
      selectCreditInvoiceProvider.getCreditInvoices(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer;
    final returnCylinderProvider =
        Provider.of<ReturnCylinderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Invoice'),
      ),
      resizeToAvoidBottomInset: false,
      body: selectedCustomer != null
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total Return Cylinder Price',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(formatPrice(returnCylinderProvider.grandPrice),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SelectCreditInvoiceSection(),
                  const SizedBox(height: 15),
                  const CreditInvoicePaidTable(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: OutlinedButton(
                      onPressed: () async {
                        returnCylinderProvider.saveReturnCylinderData(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.blue[800]),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('Select customer'),
            ),
    );
  }
}
