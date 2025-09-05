import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/issued_invoice.dart';
import 'package:gsr/modules/route_card/route_card_cash_view.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/view_issued_invoice_screen.dart';
import 'package:gsr/modules/receipt_list/receipt_list_view.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

class InvoiceSummaryScreen extends StatelessWidget {
  static const routeId = 'INVOICE_SUMMARY';
  const InvoiceSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return FutureBuilder<List<IssuedInvoice>>(
      future: getIssuedInvoices(context),
      builder: (context, AsyncSnapshot<List<IssuedInvoice>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Issued Invoices'),
          ),
          floatingActionButton:
              snapshot.hasData && dataProvider.currentRouteCard!.status == 1
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RouteCardCashView()));
                      },
                      // () => confirm(
                      //   context,
                      //   title: 'Finish',
                      //   body: 'Finish route card?',
                      //   onConfirm: () async {
                      //     pop(context);
                      //     waiting(context, body: 'Finishing...');
                      //     await updateRouteCard(
                      //       routeCardId: dataProvider.currentRouteCard!.routeCardId,
                      //       status: 2,
                      //     ).then((value) {
                      //       pop(context);
                      //       pop(context);
                      //       pop(context);
                      //     });
                      //   },
                      //   confirmText: 'Finish',
                      // ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 40,
                      ),
                    )
                  : dummy,
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ViewReceiptListScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green[700]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Previous Receipts',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                snapshot.hasData
                    ? snapshot.data!.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final issuedInvoice = snapshot.data![index];
                                return OptionCard(
                                  title:
                                      '${issuedInvoice.invoiceNo} (${issuedInvoice.customer.businessName})',
                                  subtitle: formatPrice(issuedInvoice.amount),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewIssuedInvoiceScreen(
                                        issuedInvoice: issuedInvoice,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length,
                            ),
                          )
                        : Expanded(
                            child: const Center(
                              child: Text('No invoices'),
                            ),
                          )
                    : snapshot.hasError
                        ? Center(
                            child: Text(snapshot.error.toString()),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
              ],
            ),
          ),
        );
      },
    );
  }
}
