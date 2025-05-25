import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/qr_scan_screen.dart';
import 'package:gsr/screens/select_previous_invoice_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/customer/customer_model.dart';

class PreviousScreen extends StatefulWidget {
  static const routeId = 'PREVIOUS';
  final String? qrText;
  const PreviousScreen({super.key, this.qrText});

  @override
  State<PreviousScreen> createState() => _PreviousScreenState();
}

class _PreviousScreenState extends State<PreviousScreen> {
  final qrController = TextEditingController();
  final invoiceFormKey = GlobalKey<FormState>();
  // Customer selectedCustomer;

  @override
  void initState() {
    qrController.text = widget.qrText ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedCustomer = dataProvider.selectedCustomer;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                selectedCustomer == null
                    ? image('scan')
                    : Column(
                        children: [
                          QrImageView(
                            size: 200,
                            data: qrController.text,
                          ),
                          Text(
                            selectedCustomer.businessName ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 30.0,
                ),
                TypeAheadField<CustomerModel>(
                  direction: VerticalDirection.up,
                  onSelected: (customer) => setState(() {
                    setState(() {
                      qrController.text = customer.businessName ?? '';
                      dataProvider.setSelectedCustomer(customer);
                    });
                  }),
                  itemBuilder: (context, customer) => ListTile(
                    title: Text(customer.businessName ?? ''),
                    subtitle: Text(customer.registrationId ?? ''),
                  ),
                  emptyBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('No customers matched!'),
                  ),
                  loadingBuilder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  suggestionsCallback: (pattern) => getCustomers(pattern),
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Search customer',
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: defaultBorderRadius,
                        ),
                      ),
                      onTap: () => qrController.clear(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QRScanScreen(
                                    screen: 'Previous',
                                  )));
                    },
                    icon: const Icon(
                      Icons.qr_code_rounded,
                    ),
                    label: const Text(
                      'SCAN',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                const SizedBox(
                  height: 10.0,
                ),
                if (selectedCustomer != null)
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SelectPreviousInvoiceScreen()),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800]),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
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
}
