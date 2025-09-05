import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// ignore: unused_import
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
  TextEditingController searchController = TextEditingController();
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
      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments is Map) {
        isManual = arguments['isManual'] as bool?;
      }
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
                    debounceDuration: const Duration(milliseconds: 300),
                    onSelected: (customer) {
                      setState(() {
                        qrController.text = customer.registrationId ?? '';
                        dataProvider.setSelectedCustomer(customer);
                      });
                    },
                    itemBuilder: (context, customer) => ListTile(
                      title: Text(
                        customer.businessName ?? 'No Name',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        customer.registrationId ?? 'No ID',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    emptyBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No customers available.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    loadingBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    suggestionsCallback: (pattern) async {
                      // Force a small delay to ensure the search is triggered
                      await Future.delayed(const Duration(milliseconds: 100));

                      final results = await selectCustomerViewModel
                          .onPressedSearchCustomerTextField(pattern, context);

                      return results;
                    },
                    builder: (context, controller, focusNode) {
                      // Update the TypeAheadField's controller when a customer is selected
                      if (dataProvider.selectedCustomer != null &&
                          controller.text !=
                              dataProvider.selectedCustomer!.businessName) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.text =
                              dataProvider.selectedCustomer!.businessName ?? '';
                        });
                      }

                      return TextField(
                        controller:
                            controller, // Use the controller from TypeAheadField
                        focusNode: focusNode,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Search customer',
                          hintText: 'Enter customer name or ID',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade600,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.0,
                          ),
                        ),
                        onTap: () => qrController.clear(),
                        onChanged: (value) {
                          controller.text = value;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 10.0,
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
    searchController.dispose();
    super.dispose();
  }
}
