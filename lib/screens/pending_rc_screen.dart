import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/home/home_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/route_card_screen.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingRCScreen extends StatefulWidget {
  static const routeId = 'PENDING_RC';
  const PendingRCScreen({Key? key}) : super(key: key);

  @override
  State<PendingRCScreen> createState() => _PendingRCScreenState();
}

class _PendingRCScreenState extends State<PendingRCScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Route Cards'),
        ),
        body: homeProvider.pendingRouteCards!.isNotEmpty
            ? ListView.builder(
                padding: defaultPadding,
                itemBuilder: (context, index) {
                  final routeCard = homeProvider.pendingRouteCards![index];
                  return OptionCard(
                    title:
                        '${DateFormat('yyyy-MM-dd').format(routeCard.date!)} : ${routeCard.routeCardNo} - ${routeCard.route?.routeName}',
                    titleFontSize: 20,
                    height: 30.0,
                    trailing: routeCard.status == 0
                        ? const Icon(
                            Icons.question_mark_rounded,
                            color: defaultErrorColor,
                            size: 40,
                          )
                        : routeCard.status == 1
                            ? const Icon(
                                Icons.done_rounded,
                                size: 40,
                                color: defaultAcceptColor,
                              )
                            : null,
                    onTap: () {
                      if (homeProvider.pendingRouteCards!
                              .where((rc) => rc.status == 1)
                              .isNotEmpty &&
                          homeProvider.pendingRouteCards!
                              .where((rc) => rc.status == 0)
                              .isNotEmpty &&
                          routeCard.status == 0) {
                        toast(
                          'One or more inprogress routecards available',
                          toastState: TS.error,
                        );
                      } else {
                        dataProvider.setCurrentRouteCard(routeCard);
                        Navigator.pushNamed(
                          context,
                          RouteCardScreen.routeId,
                        ).then((value) {
                          setState(() {});
                        });
                      }
                    },
                  );
                },
                itemCount: (homeProvider.pendingRouteCards ?? []).length,
              )
            : const Center(
                child: Text('No data'),
              ));
  }
}
