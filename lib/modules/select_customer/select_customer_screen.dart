import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/customer/customer_model.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/add_items_screen.dart';
import 'package:gsr/modules/return_cylinder/screens/return_cylinder_add_item_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../commons/enums.dart';
import 'select_customer_view_model.dart';

class SelectCustomerView extends StatefulWidget {
  static const routeId = 'BILLING';
  final String? qrText;
  final String? type;
  final bool? isManual;
  final AppFeatureType? featureType;
  const SelectCustomerView(
      {super.key,
      this.qrText,
      this.type = "Default",
      this.isManual = false,
      this.featureType = AppFeatureType.default_});

  @override
  State<SelectCustomerView> createState() => _SelectCustomerViewState();
}

class _SelectCustomerViewState extends State<SelectCustomerView> {
  TextEditingController qrController = TextEditingController();
  bool? isManual;
  @override
  void initState() {
    qrController.text = widget.qrText ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectCustomerViewModel = SelectCustomerViewModel();
    final routeCard = dataProvider.currentRouteCard!;
    final selectedCustomer = dataProvider.selectedCustomer;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      isManual = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)['isManual'];
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${routeCard.route?.routeName} - ${routeCard.date}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: selectedCustomer != null
            ? FloatingActionButton(
                onPressed: () {
                  if (widget.featureType == AppFeatureType.returnCylinder) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ReturnCylinderAddItemScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddItemsScreen(
                                type: widget.type,
                                isManual: isManual,
                              )),
                    );
                  }
                },
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 40,
                ),
              )
            : null,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      qrController.text = customer.registrationId ?? '';
                      dataProvider.setSelectedCustomer(customer);
                      setState(() {});
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
                    suggestionsCallback: (pattern) => selectCustomerViewModel
                        .onPressedSearchCustomerTextField(pattern, context),
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
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const QRScanScreen(
                        //               screen: 'Billing',
                        //             )));
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
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
