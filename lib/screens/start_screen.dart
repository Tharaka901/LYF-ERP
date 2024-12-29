import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/employee.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/home_screen.dart';
import 'package:gsr/screens/login_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 55.0);
    final subTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 25.0);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 5),
      () async {
        await SharedPreferences.getInstance().then((prefs) async {
          String? username = prefs.getString('username');
          String? password = prefs.getString('password');
          if (username != null && password != null) {
            waiting(context, body: 'Authenticating...');
            await loginStart(
              context,
              contactNumber: username,
              password: password,
            ).then((respo) {
              pop(context);
              if (respo.success) {
                dataProvider.setCurrentEmployee(Employee.fromJson(respo.data));
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
            Navigator.pushReplacementNamed(
              context,
              LoginScreen.routeId,
            );
          }
        });
      },
    );
    return Scaffold(
      bottomSheet: Container(
        color: Colors.black,
        height: 50.0,
        width: double.infinity,
        child: const Center(
          child: Text(
            'Copyright © 2023 Jayawardena Enterprise (Pvt) Ltd.\nAll rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/gas.png',
              width: 300.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'Distributor',
              style: mainTitleStyle,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'BILLING SYSTEM',
              style: subTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
