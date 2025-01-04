import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gsr/models/customer.dart';
import 'package:gsr/screens/select_customer_screen.dart';
import 'package:gsr/screens/previous_screen.dart';
import 'package:provider/provider.dart';

import '../commons/common_methods.dart';
import '../providers/data_provider.dart';

class QRScanScreen extends StatefulWidget {
  static const routeId = 'QR';
  final String screen;
  final String? type;
  const QRScanScreen({super.key, required this.screen, this.type});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool isSelectCustomer = false;

  _navigateNext(String code, String screen) async {
    setState(() {
      isSelectCustomer = true;
    });
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final response = await respo('customers/get-by-reg-id',
        method: Method.post, data: {"registrationId": code});
    final customer = Customer.fromJson(response.data);
    dataProvider.setSelectedCustomer(customer);

    if (screen == 'Previous') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PreviousScreen(qrText: customer.registrationId)));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SelectCustomerScreen(
                    qrText: customer.registrationId,
                    type: widget.type,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSelectCustomer
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  _navigateNext(barcodes.first.rawValue ?? '', widget.screen);
                }
              },
              // overlay: QRScannerOverlay(
              //   overlayColor: Colors.black.withOpacity(0.5),
              //   borderColor: Colors.red,
              //   borderRadius: 10,
              //   borderLength: 30,
              //   borderWidth: 10,
              // ),
            ),
    );
  }
}
