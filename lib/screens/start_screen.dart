import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../commons/common_methods.dart';
import '../models/employee/employee_model.dart';
import '../providers/data_provider.dart';
import '../services/database.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _handleAuthentication();
  }

  Future<void> _handleAuthentication() async {
    if (!mounted) return; // Check if widget is still mounted

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return; // Ensure widget is still mounted after async operation
    }

    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username == null || password == null) {
      if (mounted) _navigateToLogin(); // Ensure widget is still mounted
      return;
    }

    waiting(context, body: 'Authenticating...'); // Show waiting indicator

    try {
      final response = await loginStart(
        context,
        contactNumber: username,
        password: password,
      );

      if (!mounted) {
        return; // Ensure widget is still mounted after async operation
      }
      pop(context); // Remove waiting indicator

      if (response.success) {
        if (!mounted) return;
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        dataProvider.setCurrentEmployee(EmployeeModel.fromJson(response.data));
        if (mounted) _navigateToHome(context); // Navigate if still mounted
      } else {
        if (mounted) _navigateToLogin(); // Navigate if still mounted
      }
    } catch (e) {
      if (mounted) {
        pop(context); // Remove waiting indicator
        _navigateToLogin(); // Navigate to login on error
      }
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomeScreen.routeId);
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomSheet: _CopyrightFooter(),
      body: _SplashContent(),
    );
  }
}

class _CopyrightFooter extends StatelessWidget {
  const _CopyrightFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final mainTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 55.0);
    final subTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 25.0);

    return Container(
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
          const SizedBox(height: 5.0),
          Text('Distributor', style: mainTitleStyle),
          const SizedBox(height: 5.0),
          Text('BILLING SYSTEM', style: subTitleStyle),
        ],
      ),
    );
  }
}
