import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import '../../providers/hive_db_provider.dart';
import '../home/home_view.dart';
import '../../screens/login_screen.dart';
import '../../services/employee_service.dart';
import '../../widgets/popups/loading_popup.dart';
import '../../core/error_handler.dart';

class StartViewModel {
  Future<void> initLoad(BuildContext context) async {
    final hiveDBProvider = Provider.of<HiveDBProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await hiveDBProvider.openHiveBoxes();
    final employeeService = EmployeeService();

    String? username = hiveDBProvider.sharedPreferences?.getString('username');
    String? password = hiveDBProvider.sharedPreferences?.getString('password');
    if (username != null && password != null) {
      if (context.mounted) LoadingPopup.show(context);
      if (hiveDBProvider.isInternetConnected) {
        final response = await employeeService.login(username, password);
        if (response.success) {
          final employee = response.data!;
          await hiveDBProvider.employeeBox?.clear();
          await hiveDBProvider.employeeBox?.put(employee.employeeId, employee);
          dataProvider.setCurrentEmployee(employee);
          if (context.mounted) LoadingPopup.hide(context);
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeId);
          }
        } else {
          if (context.mounted) {
            ErrorHandler.handleApiError(context, response,
                customMessage: response.error);
          }
        }
      } else {
        if (context.mounted) {
          LoadingPopup.hide(context);
          dataProvider
              .setCurrentEmployee(hiveDBProvider.employeeBox!.values.first);
          Navigator.pushReplacementNamed(context, HomeScreen.routeId);
        }
      }
    } else {
      if (context.mounted) {
        LoadingPopup.hide(context);
        Navigator.pushReplacementNamed(context, LoginScreen.routeId);
      }
    }
  }
}
