import 'package:flutter/material.dart';
import 'package:gsr/modules/start/start_view_model.dart';

const TextStyle mainTitleStyle = TextStyle(
  color: Color(0xFF616161), // Colors.grey[700]
  fontSize: 55.0,
);

const TextStyle subTitleStyle = TextStyle(
  color: Color(0xFF616161), // Colors.grey[700]
  fontSize: 25.0,
);

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  late final StartViewModel startViewModel;

  @override
  void initState() {
    super.initState();
    startViewModel = StartViewModel();
    startViewModel.initLoad(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const _CopyrightFooter(),
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
            const SizedBox(height: 5.0),
            const Text(
              'Distributor',
              style: mainTitleStyle,
            ),
            const SizedBox(height: 5.0),
            const Text(
              'BILLING SYSTEM',
              style: subTitleStyle,
            ),
          ],
        ),
      ),
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
