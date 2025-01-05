import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/cheque.dart';
import 'package:gsr/models/voucher.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/cheque_card.dart';
import 'package:gsr/widgets/cheque_form.dart';
import 'package:gsr/widgets/detail_card.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:provider/provider.dart';

import '../modules/view_receipt/previous_view_receipt_screen.dart';

class PreviousAddPaymentScreen extends StatefulWidget {
  static const routeId = 'PREVIOUS_PAYMENT';
  const PreviousAddPaymentScreen({Key? key}) : super(key: key);

  @override
  State<PreviousAddPaymentScreen> createState() =>
      _PreviousAddPaymentScreenState();
}

class _PreviousAddPaymentScreenState extends State<PreviousAddPaymentScreen> {
  final chequeScrollController = ScrollController();
  final cashController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if ((cashController.text.trim().isEmpty &&
          //     dataProvider.chequeList.isEmpty) || dataProvider.getTotalDepositePaymentAmount() ) {
          //   return;
          // }
          if (dataProvider.chequeList.isEmpty) {
            if ((doub(cashController.text.trim().isEmpty
                    ? dataProvider.getTotalDepositePaymentAmount().toString()
                    : (double.parse(cashController.text
                                .trim()
                                .replaceAll(',', '')) +
                            dataProvider.getTotalDepositePaymentAmount())
                        .toString())) <
                dataProvider.issuedInvoicePaidList
                    .map((e) => e.paymentAmount)
                    .toList()
                    .reduce((value, element) => value + element)) {
              return;
            }
          } else {
            if ((cashController.text.trim().isEmpty
                    ? (dataProvider.getTotalDepositePaymentAmount() +
                        dataProvider.chequeList
                            .map((e) => e.chequeAmount)
                            .toList()
                            .reduce((value, element) => value + element))
                    : (double.parse(cashController.text
                                .trim()
                                .replaceAll(',', '')) +
                            dataProvider.getTotalDepositePaymentAmount()) +
                        dataProvider.chequeList
                            .map((e) => e.chequeAmount)
                            .toList()
                            .reduce((value, element) => value + element)) <
                dataProvider.issuedInvoicePaidList
                    .map((e) => e.paymentAmount)
                    .toList()
                    .reduce((value, element) => value + element)) {
              return;
            }
          }

          Navigator.pushNamed(context, PreviousViewReceiptScreen.routeId,
              arguments: {
                'cash': doub(cashController.text.trim().isEmpty
                    ? '0.0'
                    : cashController.text.trim().replaceAll(',', ''))
              });
        },
        child: const Icon(
          Icons.arrow_forward_rounded,
          size: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: defaultPadding,
            child: Column(
              children: [
                DetailCard(
                  detailKey: 'Date',
                  detailvalue: date(DateTime.now(), format: 'dd.MM.yyyy'),
                ),
                DetailCard(
                  detailKey: 'Customer name',
                  detailvalue: dataProvider.selectedCustomer!.businessName,
                ),
                DetailCard(
                  detailKey: 'Total amount',
                  detailvalue:
                      formatPrice(dataProvider.getTotalInvoicePaymentAmount()),
                ),
                TextFormField(
                  controller: cashController,
                  // inputFormatters: [
                  //   ThousandsFormatter(
                  //     allowFraction: true,
                  //   ),
                  // ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Cash',
                    prefixText: 'Rs. ',
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () {
                      final chequeNumberController = TextEditingController();
                      final chequeAmountController = TextEditingController();
                      final formKey = GlobalKey<FormState>();
                      confirm(
                        context,
                        title: 'New Cheque',
                        body: ChequeForm(
                          chequeNumberController: chequeNumberController,
                          chequeAmountController: chequeAmountController,
                          formKey: formKey,
                        ),
                        onConfirm: () {
                          if (formKey.currentState!.validate()) {
                            dataProvider.addCheque(
                              Cheque(
                                chequeNumber:
                                    chequeNumberController.text.trim(),
                                chequeAmount: doub(chequeAmountController.text
                                    .replaceAll(',', '')),
                              ),
                            );
                            chequeNumberController.clear();
                            chequeAmountController.clear();
                            return;
                          }
                        },
                        confirmText: 'Add',
                      );
                    },
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
                      'New cheque',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Consumer<DataProvider>(
                  builder: (context, data, _) => data.chequeList.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 300.0,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListView.separated(
                              itemCount: data.chequeList.length,
                              controller: chequeScrollController,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 5.0,
                              ),
                              itemBuilder: (context, index) {
                                final cheque = data.chequeList[index];
                                return ChequeCard(
                                  chequeNumber: cheque.chequeNumber,
                                  chequeAmount: cheque.chequeAmount,
                                  trailing: IconButton(
                                    splashRadius: 20.0,
                                    onPressed: () => data.removeCheque(cheque),
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      color: defaultErrorColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : dummy,
                ),
                const Divider(),
                FutureBuilder<List<Voucher>>(
                  future: getVouchers(context),
                  builder: (context, AsyncSnapshot<List<Voucher>> snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : DropdownButtonFormField<Voucher>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: snapshot.hasData &&
                                        snapshot.data!.isNotEmpty
                                    ? 'Select voucher'
                                    : 'No vouchers available',
                              ),
                              value: null,
                              items: snapshot.hasData
                                  ? snapshot.data!.map((element) {
                                      return DropdownMenuItem(
                                        value: element,
                                        child: Text(
                                            '${element.code} ${element.id != 0 ? formatPrice(element.value) : ''}'),
                                      );
                                    }).toList()
                                  : [],
                              onChanged: (voucher) {
                                if (voucher != null && voucher.id != 0) {
                                  dataProvider.setSelectedVoucher(voucher);
                                } else {
                                  dataProvider.setSelectedVoucher(null);
                                }
                              },
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
