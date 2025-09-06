import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'modules/start/start_view.dart';
import 'screens/start_screen.dart';

class GSRApp extends StatelessWidget {
  const GSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSR App',
      theme: AppTheme.light,
      home: const StartView(),
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}
