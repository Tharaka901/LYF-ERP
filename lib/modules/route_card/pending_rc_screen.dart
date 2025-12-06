import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/home/home_provider.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/route_card_screen.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

class PendingRCScreen extends StatefulWidget {
  static const routeId = 'PENDING_RC';
  const PendingRCScreen({super.key});

  @override
  State<PendingRCScreen> createState() => _PendingRCScreenState();
}

class _PendingRCScreenState extends State<PendingRCScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh route cards when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.getPendingRouteCards(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Cards'),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoadingRouteCards) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final routeCards = homeProvider.pendingRouteCards ?? [];

          if (routeCards.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          }

          return ListView.builder(
            padding: defaultPadding,
            itemBuilder: (context, index) {
              final routeCard = routeCards[index];
              return OptionCard(
                title:
                    '${routeCard.date?.toString().split(' ')[0]} : ${routeCard.routeCardNo} - ${routeCard.route?.routeName}',
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
                  if (routeCards.where((rc) => rc.status == 1).isNotEmpty &&
                      routeCards.where((rc) => rc.status == 0).isNotEmpty &&
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
                      // Refresh route cards when returning from RouteCardScreen
                      homeProvider.getPendingRouteCards(context);
                    });
                  }
                },
              );
            },
            itemCount: routeCards.length,
          );
        },
      ),
    );
  }
}
