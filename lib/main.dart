import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'commons/hive_db.dart';
import 'commons/locator.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //! Register Hive Models
  await registerHiveModels();

  //! Set system UI style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Setup dependency injection
  setupLocator();

  runApp(MultiProvider(
    providers: AppProviders.providers,
    child: const GSRApp(),
  ));
}
