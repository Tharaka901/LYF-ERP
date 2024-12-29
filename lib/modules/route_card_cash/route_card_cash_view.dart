import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../providers/data_provider.dart';
import '../../services/database.dart';
import 'route_card_cash_provider.dart';

class RouteCardCashView extends StatefulWidget {
  RouteCardCashView({super.key});

  @override
  State<RouteCardCashView> createState() => _RouteCardCashViewState();
}

class _RouteCardCashViewState extends State<RouteCardCashView> {
  RouteCardCashProvider? cashProvider;

  @override
  void initState() {
    cashProvider = Provider.of<RouteCardCashProvider>(context, listen: false);
    cashProvider!.addCashListeners();
    super.initState();
  }

  @override
  void dispose() {
    //cashProvider!.disposeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Cash Settlement Data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => confirm(
          context,
          title: 'Finish',
          body: 'Finish route card?',
          onConfirm: () async {
            pop(context);
            waiting(context, body: 'Finishing...');
            await cashProvider!.completeRC(context);
            await updateRouteCard(
              routeCardId: dataProvider.currentRouteCard!.routeCardId,
              status: 2,
            ).then((value) {
              pop(context);
              pop(context);
              pop(context);
              pop(context);
            });
          },
          confirmText: 'Finish',
        ),
        child: const Icon(
          Icons.done,
          size: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCashEntryField('5000', cashProvider!.cash5000Controller),
            _buildCashEntryField('2000', cashProvider!.cash2000Controller),
            _buildCashEntryField('1000', cashProvider!.cash1000Controller),
            _buildCashEntryField('500', cashProvider!.cash500Controller),
            _buildCashEntryField('200', cashProvider!.cash200Controller),
            _buildCashEntryField('100', cashProvider!.cash100Controller),
            _buildCashEntryField('50', cashProvider!.cash50Controller),
            _buildCashEntryField('20', cashProvider!.cash20Controller),
            _buildCashEntryField('10', cashProvider!.cash10Controller),
            _buildCashEntryField('Coins', cashProvider!.coinController),
            SizedBox(height: 20),
            Consumer<RouteCardCashProvider>(builder: (context, cash, __) {
              return Text(
                'Total - Rs ${cash.totalCash}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildCashEntryField(
      String denomination, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter quantity of $denomination',
        ),
      ),
    );
  }
}
