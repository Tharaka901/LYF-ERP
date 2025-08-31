import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/route_card.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/invoice_summary_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../models/route_card/route_card_model.dart';

class CompletedRCScreen extends StatefulWidget {
  static const routeId = 'COMPLETED_RC';
  const CompletedRCScreen({super.key});

  @override
  State<CompletedRCScreen> createState() => _CompletedRCScreenState();
}

// class _CompletedRCScreenState extends State<CompletedRCScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Completed Route Cards'),
//       ),
//       body: FutureBuilder<List<RouteCard>>(
//         future: getRouteCards(
//           dataProvider.currentEmployee!.employeeId,
//           rcStatus: RC.completed,
//         ),
//         builder: (context, AsyncSnapshot<List<RouteCard>> snapshot) =>
//             snapshot.connectionState == ConnectionState.waiting
//                 ? const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : snapshot.hasData
//                     ? snapshot.data!.isNotEmpty
//                         ? ListView.builder(
//                             padding: defaultPadding,
//                             reverse: true,
//                             itemBuilder: (context, index) {
//                               final routeCard = snapshot.data![index];
//                               if (snapshot.data!.length > 100) {
//                                 if (index < snapshot.data!.length - 100) {
//                                   return SizedBox.shrink();
//                                 }
//                               }
//                               return OptionCard(
//                                 title: routeCard.date,
//                                 subtitle: routeCard.routeCardNo,
//                                 trailing: routeCard.status == 0
//                                     ? const Icon(
//                                         Icons.question_mark_rounded,
//                                         color: defaultErrorColor,
//                                       )
//                                     : routeCard.status == 1
//                                         ? const Icon(
//                                             Icons.done_rounded,
//                                             color: defaultAcceptColor,
//                                           )
//                                         : null,
//                                 onTap: () {
//                                   dataProvider.setCurrentRouteCard(routeCard);
//                                   Navigator.pushNamed(
//                                     context,
//                                     InvoiceSummaryScreen.routeId,
//                                   ).then((value) {
//                                     setState(() {});
//                                   });
//                                 },
//                               );
//                             },
//                             itemCount: (snapshot.data ?? []).length,
//                           )
//                         : const Center(
//                             child: Text('No data'),
//                           )
//                     : const Center(
//                         child: Text('No invoices'),
//                       ),
//       ),
//     );
//   }
// }

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
        builder: (context, AsyncSnapshot<List<RouteCardModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final routeCards = snapshot.data!;

            // Sort the list by date in descending order
            routeCards.sort((a, b) =>
                DateTime.parse(date(a.date!, format: 'yyyy-MM-dd')).compareTo(
                    DateTime.parse(date(b.date!, format: 'yyyy-MM-dd'))));

            return routeCards.isNotEmpty
                ? ListView.builder(
                    padding: defaultPadding,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final routeCard = routeCards[index];
                      if (routeCards.length > 50 &&
                          index < routeCards.length - 50) {
                        return SizedBox.shrink();
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
                            InvoiceSummaryScreen.routeId,
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      );
                    },
                    itemCount: routeCards.length,
                  )
                : const Center(
                    child: Text('No data'),
                  );
          } else {
            return const Center(
              child: Text('No invoices'),
            );
          }
        },
      ),
    );
  }
}
