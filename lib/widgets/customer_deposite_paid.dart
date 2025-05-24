import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/balance.dart';
import 'package:gsr/models/customer_deposite.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

import '../models/issued_invoice_paid_model/issued_invoice_paid.dart';

class CustomerDepositePaid extends StatefulWidget {
  final double balnce;
  final TextEditingController paymentController;
  final GlobalKey<FormState> formKey;
  // final double balance;
  final void Function(Balance selectedBalance) callBack;
  const CustomerDepositePaid({
    super.key,
    required this.paymentController,
    required this.formKey,
    required this.callBack,
    required this.balnce,
    // required this.balance,
  });

  @override
  State<CustomerDepositePaid> createState() => _CustomerDepositePaidState();
}

class _CustomerDepositePaidState extends State<CustomerDepositePaid> {
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
            FutureBuilder<List<CustomerDeposite>>(
              future: getCustomerDeposites(context,
                  cId: dataProvider.selectedCustomer!.customerId,
                  routecardId: dataProvider.currentRouteCard?.routeCardId),
              builder:
                  (context, AsyncSnapshot<List<CustomerDeposite>> snapshot) {
                return DropdownButtonFormField<CustomerDeposite>(
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
                              '${element.receiptNo}  ${formatPrice(element.value?.toDouble() ?? 0)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList()
                      : [],
                  onChanged: (deposite) {
                    dataProvider.setSelectedDeposite(deposite);
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
                  } else if (doub(text) > (data.selectedDeposite?.value)) {
                    return 'Maximum ${formatPrice(data.selectedDeposite?.value?.toDouble() ?? 0)}';
                  } else if (doub(text) > (-widget.balnce)) {
                    return 'Maximum ${formatPrice(-widget.balnce)}';
                  }
                  data.addPaidDeposite(
                    IssuedDepositePaidModel(
                      depositeValue: data.selectedDeposite!.value?.toDouble(),
                      issuedDeposite: data.selectedDeposite!,
                      paymentAmount: doub(
                          widget.paymentController.text.replaceAll(',', '')),
                    ),
                  );
                  data.setSelectedDeposite(null);
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
