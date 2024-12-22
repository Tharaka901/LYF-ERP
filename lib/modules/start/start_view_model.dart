import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/common_methods.dart';
import '../../models/employee/employee_model.dart';
import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import '../home/home_view.dart';
import '../../screens/login_screen.dart';
import '../../services/database.dart';

class StartViewModel {
  Future<void> initLoad(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await hiveDBProvider.openHiveBoxes();
    String? username = hiveDBProvider.sharedPreferences?.getString('username');
    String? password = hiveDBProvider.sharedPreferences?.getString('password');
    if (username != null && password != null) {
      waiting(context, body: 'Authenticating...');
      if (hiveDBProvider.isInternetConnected) {
        await loginStart(
          context,
          contactNumber: username,
          password: password,
        ).then((respo) async {
          pop(context);
          if (respo.success) {
            final employee = EmployeeModel.fromJson(respo.data);
            hiveDBProvider.employeeBox?.put(employee.employeeId, employee);
            dataProvider.setCurrentEmployee(EmployeeModel.fromJson(respo.data));
            Navigator.pushReplacementNamed(
              context,
              HomeScreen.routeId,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              LoginScreen.routeId,
            );
          }
        });
      } else {
        dataProvider
            .setCurrentEmployee(hiveDBProvider.employeeBox!.values.first);
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.routeId,
        );
      }
    } else {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeId,
      );
    }
  }
}
