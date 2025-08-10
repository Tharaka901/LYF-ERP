import 'package:flutter/material.dart';
import 'package:gsr/modules/stock/stock_view_model.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import 'components/issued_stock.dart';
import 'components/leak_stock.dart';
import 'components/loan_stock.dart';
import 'components/received_stock.dart';
import 'components/return_cylinder_stock.dart';

class StockScreen extends StatefulWidget {
  // final List<RcItemsSummary> rcItemSummary;
  static const routeId = 'STOCK';
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  StockViewModel stockViewModel = StockViewModel();

  @override
  void initState() {
    stockViewModel.loadStockData(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: ChangeNotifierProvider<StockViewModel>(
          create: (context) => stockViewModel,
          child: Consumer<StockViewModel>(
            builder: (context, stockViewModelData, child) {
              return stockViewModelData.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Date:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      date(dataProvider.currentRouteCard!.date!,
                                          format: 'dd.MM.yyyy'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Route:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      dataProvider.currentRouteCard?.route
                                              ?.routeName ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Route Card No:',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      dataProvider
                                              .currentRouteCard?.routeCardNo ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const IssuedStock(),
                        const SizedBox(height: 10),
                        const ReceivedStock(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const LoanStockSection(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const LeakStockSection(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const ReturnCylinderStockSection(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
