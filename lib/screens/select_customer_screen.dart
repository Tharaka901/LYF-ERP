import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../commons/common_methods.dart';
import '../models/customer.dart';
import '../providers/data_provider.dart';
import '../services/database.dart';
import 'add_items_screen.dart';
import 'qr_scan_screen.dart';
import '../config/styles.dart';

class SelectCustomerScreen extends StatefulWidget {
  static const routeId = 'BILLING';

  final String? qrText;
  final String? type;
  final bool? isManual;

  const SelectCustomerScreen({
    super.key,
    this.qrText,
    this.type = "Default",
    this.isManual = false,
  });

  @override
  State<SelectCustomerScreen> createState() => _SelectCustomerScreenState();
}

class _SelectCustomerScreenState extends State<SelectCustomerScreen> {
  final TextEditingController _qrController = TextEditingController();
  bool? _isManual;

  @override
  void initState() {
    super.initState();
    _qrController.text = widget.qrText ?? '';
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  void _handleCustomerSelection(Customer customer, DataProvider dataProvider) {
    setState(() {
      _qrController.text = customer.registrationId;
      dataProvider.setSelectedCustomer(customer);
    });
  }

  void _navigateToQRScan() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QRScanScreen(
          screen: 'Billing',
          type: widget.type,
        ),
      ),
    );
  }

  void _navigateToAddItems() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemsScreen(
          type: widget.type,
          isManual: _isManual,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCard = dataProvider.currentRouteCard!;
    final selectedCustomer = dataProvider.selectedCustomer;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      _isManual = (ModalRoute.of(context)!.settings.arguments
          as Map<dynamic, dynamic>)['isManual'];
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(routeCard),
        floatingActionButton: _buildFloatingActionButton(selectedCustomer),
        body: _buildBody(selectedCustomer, dataProvider),
      ),
    );
  }

  AppBar _buildAppBar(dynamic routeCard) {
    return AppBar(
      title: Text(
        '${routeCard.route.routeName} - ${routeCard.date}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget? _buildFloatingActionButton(Customer? selectedCustomer) {
    return selectedCustomer != null
        ? FloatingActionButton(
            onPressed: _navigateToAddItems,
            child: const Icon(Icons.arrow_forward_rounded, size: 40),
          )
        : null;
  }

  Widget _buildBody(Customer? selectedCustomer, DataProvider dataProvider) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCustomerDisplay(selectedCustomer),
              const SizedBox(height: 30.0),
              _buildCustomerSearch(dataProvider),
              const SizedBox(height: 20.0),
              _buildScanButton(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerDisplay(Customer? selectedCustomer) {
    return selectedCustomer == null
        ? image('scan')
        : Column(
            children: [
              QrImageView(
                size: 200,
                data: _qrController.text,
              ),
              Text(
                selectedCustomer.businessName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
  }

  Widget _buildCustomerSearch(DataProvider dataProvider) {
    return TypeAheadField<Customer>(
      direction: VerticalDirection.up,
      onSelected: (customer) =>
          _handleCustomerSelection(customer, dataProvider),
      itemBuilder: (context, customer) => ListTile(
        title: Text(customer.businessName),
        subtitle: Text(customer.registrationId),
      ),
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('No customers matched!'),
      ),
      loadingBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),
      suggestionsCallback: getCustomers,
      builder: _buildSearchField,
    );
  }

  Widget _buildSearchField(BuildContext context,
      TextEditingController controller, FocusNode focusNode) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: AppStyles.textFieldDecoration(
        labelText: 'Search customer',
        fillColor: Colors.grey[200],
      ),
      onTap: () => _qrController.clear(),
    );
  }

  Widget _buildScanButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton.icon(
        onPressed: _navigateToQRScan,
        icon: const Icon(Icons.qr_code_rounded),
        label: const Text(
          'SCAN',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
