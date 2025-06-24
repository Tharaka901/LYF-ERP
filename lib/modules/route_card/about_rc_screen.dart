import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/widgets/detail_card.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

import '../../widgets/buttons/custom_outline_button.dart';
import 'route_card_view_model.dart';

class AboutRCScreen extends StatelessWidget {
  static const routeId = 'ABOUT_RC';
  const AboutRCScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCardViewModel = RouteCardViewModel();
    final routeCard = dataProvider.currentRouteCard!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${routeCard.routeCardNo} - ${routeCard.date}'),
      ),
      body: Padding(
        padding: defaultPadding,
        child: ListView(
          children: [
            DetailCard(
              detailKey: 'Route',
              detailvalue:
                  dataProvider.currentRouteCard?.route?.routeName ?? "",
            ),
            DetailCard(
              detailKey: 'Vehicle Number',
              detailvalue:
                  dataProvider.currentRouteCard?.vehicle?.registrationNumber ?? "",
            ),
            DetailCard(
              detailKey: 'Driver',
              detailvalue:
                  '${dataProvider.currentEmployee!.firstName} ${dataProvider.currentEmployee!.lastName}',
            ),
            const Divider(),
            ...routeCard.relatedEmployees!
                .where((re) =>
                    re.employee?.employeeId !=
                    dataProvider.currentEmployee!.employeeId)
                .map(
                  (re) => DetailCard(
                    detailKey: 'Helper',
                    detailvalue:
                        '${re.employee?.firstName} ${re.employee?.lastName}',
                  ),
                ),
            const Divider(),
            ...dataProvider.rcItemList.map(
              (rci) {
                return OptionCard(
                  height: 20,
                  title: rci.item?.itemName ?? '',
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
            if (routeCard.status == 0) ...[
              const SizedBox(height: 10),
              CustomOutlineButton(
                text: 'Accept',
                onPressed: () {
                  routeCardViewModel.onPressedAcceptButton(context);
                },
                color: Colors.blue[800],
              ),
              const SizedBox(height: 10),
              CustomOutlineButton(
                text: 'Accept & Print',
                onPressed: () {
                  routeCardViewModel.onPressedAcceptAndPrintButton(context);
                },
                color: Colors.blue[800],
              ),
              const SizedBox(height: 10),
              CustomOutlineButton(
                text: 'Reject',
                onPressed: () {
                  routeCardViewModel.onPressedRejectButton(context);
                },
                color: Colors.red[800],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
