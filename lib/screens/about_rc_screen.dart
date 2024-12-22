import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/widgets/detail_card.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

class AboutRCScreen extends StatelessWidget {
  static const routeId = 'ABOUT_RC';
  const AboutRCScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCard = dataProvider.currentRouteCard!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${routeCard.routeCardNo} - ${routeCard.date}'),
      ),
      floatingActionButton: routeCard.status == 0
          ? FloatingActionButton(
              onPressed: () {
                confirm(
                  context,
                  title: '',
                  body: 'Accept or reject this R/C',
                  onConfirm: () {
                    pop(context);
                    popValue(
                      context,
                      value: 1,
                    );
                  },
                  confirmText: 'Accept',
                  moreActions: [
                    TextButton(
                      onPressed: () {
                        pop(context);
                        popValue(
                          context,
                          value: 4,
                        );
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.question_mark_rounded,
                size: 40,
              ),
            )
          : dummy,
      body: Padding(
        padding: defaultPadding,
        child: ListView(
          children: [
            DetailCard(
              detailKey: 'Driver',
              detailvalue:
                  '${dataProvider.currentEmployee!.firstName} ${dataProvider.currentEmployee!.lastName}',
            ),
            const Divider(),
            ...routeCard.relatedEmployees!
                .where((re) =>
                    re.employee!.employeeId! !=
                    dataProvider.currentEmployee!.employeeId)
                .map(
                  (re) => DetailCard(
                    detailKey: 'Helper',
                    detailvalue:
                        '${re.employee!.firstName} ${re.employee!.lastName}',
                  ),
                ),
            const Divider(),
            ...dataProvider.rcItemList.map(
              (rci) {
                return OptionCard(
                  // leading: image(
                  //   '12.5',
                  // ),
                  height: 20,
                  title: (rci.item!).itemName,
                  titleFontSize: 20.0,
                  trailing: Text(
                    num(rci.transferQty),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
