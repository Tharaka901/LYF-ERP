import 'package:flutter/material.dart';
import 'package:gsr/modules/start/start_view_model.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  void initState() {
    final startViewModel = StartViewModel();
    startViewModel.initLoad(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 55.0);
    final subTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 25.0);
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
