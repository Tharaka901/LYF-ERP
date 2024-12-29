import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/screens/completed_rc_screen.dart';
import 'package:gsr/screens/login_screen.dart';
import 'package:gsr/screens/pending_rc_screen.dart';
import 'package:gsr/services/database.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  static const routeId = 'HOME';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50.0,
              ),
              CircleAvatar(
                backgroundImage: const NetworkImage(
                    'https://learn.microsoft.com/answers/storage/attachments/209536-360-f-364211147-1qglvxv1tcq0ohz3fawufrtonzz8nq3e.jpg'),
                radius: width * 0.2,
              ),
              Text(
                '${dataProvider.currentEmployee!.firstName} ${dataProvider.currentEmployee!.lastName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.07,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OptionCard(
                      title: 'Pending R/C',
                      titleFontSize: 25.0,
                      trailing: const Icon(
                        Icons.history_rounded,
                        size: 50.0,
                        color: Colors.red,
                      ),
                      onTap: () async {
                        waiting(context, body: 'Checking...');

                        await getPendingAndAcceptedRouteCards(
                                dataProvider.currentEmployee!.employeeId)
                            .then((rcs) {
                          pop(context);
                          if (rcs.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              PendingRCScreen.routeId,
                            );
                          } else {
                            toast(
                              'No routecards available',
                              toastState: TS.error,
                            );
                          }
                        });
                      },
                      verticlePadding: 10.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    OptionCard(
                      title: 'Completed R/C',
                      titleFontSize: 25.0,
                      trailing: const Icon(
                        Icons.done_all_rounded,
                        size: 50.0,
                        color: Colors.green,
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        CompletedRCScreen.routeId,
                      ),
                      verticlePadding: 10.0,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60.0,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[600]),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Change password',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60.0,
                      child: OutlinedButton(
                        onPressed: () => confirm(
                          context,
                          title: 'Logout',
                          body: 'You are about to logout',
                          confirmText: 'Logout',
                          onConfirm: () async {
                            pop(context);
                            waiting(context, body: 'Logging out...');
                            await SharedPreferences.getInstance()
                                .then((prefs) async {
                              await prefs.remove('username').then((_) async {
                                await prefs.remove('password').then((_) {
                                  pop(context);
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LoginScreen.routeId,
                                    (route) => false,
                                  );
                                });
                              });
                            });
                          },
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[500]),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
