import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/route_card/route_card_model.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/modules/issued_invoice_list/issued_invoice_list_view.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

class CompletedRCScreen extends StatefulWidget {
  static const routeId = 'COMPLETED_RC';
  const CompletedRCScreen({Key? key}) : super(key: key);

  @override
  State<CompletedRCScreen> createState() => _CompletedRCScreenState();
}

class _CompletedRCScreenState extends State<CompletedRCScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Route Cards'),
      ),
      body: FutureBuilder<List<RouteCardModel>>(
        future: getRouteCards(
          dataProvider.currentEmployee!.employeeId!,
          rcStatus: RC.completed,
        ),
        builder: (context, AsyncSnapshot<List<RouteCardModel>> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.hasData
                    ? snapshot.data!.isNotEmpty
                        ? ListView.builder(
                            padding: defaultPadding,
                            reverse: true,
                            itemBuilder: (context, index) {
                              final routeCard = snapshot.data![index];
                              if (snapshot.data!.length > 10) {
                                if (index < snapshot.data!.length - 10) {
                                  return SizedBox.shrink();
                                }
                              }
                              return OptionCard(
                                title: routeCard.date?.toString().split(' ')[0] ?? 'No Date',
                                subtitle: routeCard.routeCardNo,
                                trailing: routeCard.status == 0
                                    ? const Icon(
                                        Icons.question_mark_rounded,
                                        color: defaultErrorColor,
                                      )
                                    : routeCard.status == 1
                                        ? const Icon(
                                            Icons.done_rounded,
                                            color: defaultAcceptColor,
                                          )
                                        : null,
                                onTap: () {
                                  dataProvider.setCurrentRouteCard(routeCard);
                                  Navigator.pushNamed(
                                    context,
                                    IssuedInvoiceListView.routeId,
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                              );
                            },
                            itemCount: (snapshot.data ?? []).length,
                          )
                        : const Center(
                            child: Text('No data'),
                          )
                    : const Center(
                        child: Text('No invoices'),
                      ),
      ),
    );
  }
}
