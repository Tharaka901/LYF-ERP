import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/balance.dart';
import 'package:gsr/models/customer_deposite.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

import '../models/issued_invoice.dart';

class CustomerDepositePaidForPriviousInvoice extends StatefulWidget {
  final TextEditingController paymentController;
  final GlobalKey<FormState> formKey;
  final void Function(Balance selectedBalance) callBack;
  const CustomerDepositePaidForPriviousInvoice({
    Key? key,
    required this.paymentController,
    required this.formKey,
    required this.callBack,
    // required this.balance,
  }) : super(key: key);

  @override
  State<CustomerDepositePaidForPriviousInvoice> createState() =>
      _CustomerDepositePaidForPriviousInvoiceState();
}

class _CustomerDepositePaidForPriviousInvoiceState
    extends State<CustomerDepositePaidForPriviousInvoice> {
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
              future: creditInvoices(context,
                  cId: dataProvider.selectedCustomer!.customerId,
                  type: 'with-cheque'),
              builder: (context, AsyncSnapshot<List<IssuedInvoice>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  if (snapshot.data!.isNotEmpty) {
                    dataProvider.setSelectedInvoice(snapshot.data![0]);
                  }
                }
                ;
                return snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<IssuedInvoice>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? 'Loading...'
                                      : (snapshot.hasData &&
                                              snapshot.data!.isNotEmpty
                                          ? 'Select credit invoice'
                                          : 'No previous invoices'),
                                ),
                                value: snapshot.hasData &&
                                        snapshot.data!.isNotEmpty
                                    ? snapshot.data![0]
                                    : null,
                                validator: (value) {
                                  if (dataProvider.selectedInvoice == null) {
                                    return 'Select an invoice!';
                                  } else if (dataProvider.issuedInvoicePaidList
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
                                              '${element.invoiceNo}  ${formatPrice(element.creditValue)}',
                                              style: TextStyle(fontSize: 12)),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (invoice) {
                                  dataProvider.setSelectedInvoice(invoice);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
            SizedBox(height: 15),
            FutureBuilder<List<CustomerDeposite>>(
              future: getCustomerDeposites(context,
                  cId: dataProvider.selectedCustomer!.customerId,
                  routecardId: dataProvider.currentRouteCard?.routeCardId),
              builder:
                  (context, AsyncSnapshot<List<CustomerDeposite>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting &&
                    snapshot.hasData) if (snapshot.data!.isNotEmpty) {
                  dataProvider.setSelectedDeposite(snapshot.data![0]);
                }
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
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Select an invoice!';
                  //   } else if (dataProvider.paidBalanceList
                  //       .where((element) =>
                  //           element.balance.customerBalanceId ==
                  //           value.customerBalanceId)
                  //       .isNotEmpty) {
                  //     return 'Already added!';
                  //   }
                  //   return null;
                  // },
                  items: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data!.map((element) {
                          return DropdownMenuItem(
                            value: element,
                            child: Text(
                              '${element.receiptNo}  ${formatPrice(element.value?.toDouble() ?? 0)}',
                              style: TextStyle(fontSize: 12),
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
                  } else if (doub(text) >
                      (double.parse(data.selectedInvoice?.creditValue
                              .toStringAsFixed(2) ??
                          '0'))) {
                    return 'Maximum ${formatPrice(data.selectedInvoice?.creditValue.toDouble() ?? 0)}';
                  }

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
