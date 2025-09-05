import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/receipt_summary/receipt_summary_view.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

import '../../models/credit_payment/credit_payment_model.dart';
import '../../services/database.dart';

class ViewReceiptListScreen extends StatefulWidget {
  const ViewReceiptListScreen({Key? key}) : super(key: key);

  @override
  State<ViewReceiptListScreen> createState() => _ViewReceiptListScreenState();
}

class _ViewReceiptListScreenState extends State<ViewReceiptListScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return FutureBuilder<List<CreditPaymentModel>>(
      future: getCreditPayments(
          routecardId: dataProvider.currentRouteCard!.routeCardId!),
      builder: (context, AsyncSnapshot<List<CreditPaymentModel>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Receipts'),
            actions: [
              snapshot.hasData &&
                      snapshot.data!.isNotEmpty &&
                      dataProvider.currentRouteCard!.status == 1
                  ? IconButton(
                      onPressed: () => confirm(context,
                          title: 'Finish',
                          body: 'Finish route card?', onConfirm: () async {
                        pop(context);
                        waiting(context, body: 'Finishing...');
                        await updateRouteCard(
                          routeCardId:
                              dataProvider.currentRouteCard!.routeCardId!,
                          status: 2,
                        ).then((value) {
                          pop(context);
                          pop(context);
                          pop(context);
                        });
                      }, confirmText: 'Finish'),
                      icon: const Icon(Icons.done),
                    )
                  : dummy,
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: snapshot.hasData
                ? snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final receipt = snapshot.data![index];

                          return OptionCard(
                            title:
                                '${receipt.receiptNo} (${receipt.creditInvoice?.customer?.businessName})',
                            subtitle: receipt.payments!.isNotEmpty
                                ? formatPrice(receipt.payments!
                                        .map((e) => e.amount)
                                        .reduce((value, element) =>
                                            value! + element!) ??
                                    0)
                                : '',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptSummaryView(
                                  creditPayment: receipt,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                      )
                    : const Center(
                        child: Text('No receipts'),
                      )
                : snapshot.hasError
                    ? Center(
                        child: Text(snapshot.error.toString()),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
          ),
        );
      },
    );
  }
}
