import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../commons/common_methods.dart';
import '../models/customer/customer_model.dart';
import '../models/route_card.dart';
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
  DataProvider? dataProvider;
  CustomerModel? selectedCustomer;
  RouteCard? routeCard;
  bool? _isManual;

  final TextEditingController _qrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    _qrController.text = widget.qrText ?? '';
    selectedCustomer = dataProvider!.selectedCustomer;
    routeCard = dataProvider!.currentRouteCard;
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  void _handleCustomerSelection(
      CustomerModel customer, DataProvider dataProvider) {
    setState(() {
      _qrController.text = customer.registrationId ?? '';
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
    if (ModalRoute.of(context)?.settings.arguments != null) {
      _isManual = (ModalRoute.of(context)!.settings.arguments
          as Map<dynamic, dynamic>)['isManual'];
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        '${routeCard!.route.routeName} - ${routeCard!.date}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        if (dataProvider.selectedCustomer != null) {
          return FloatingActionButton(
            onPressed: _navigateToAddItems,
            child: const Icon(Icons.arrow_forward_rounded, size: 40),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCustomerDisplay(),
              const SizedBox(height: 30.0),
              _buildCustomerSearch(),
              const SizedBox(height: 20.0),
              _buildScanButton(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerDisplay() {
    return selectedCustomer == null
        ? image('scan')
        : Column(
            children: [
              QrImageView(
                size: 200,
                data: _qrController.text,
              ),
              Text(
                selectedCustomer!.businessName ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
  }

  Widget _buildCustomerSearch() {
    return TypeAheadField<CustomerModel>(
      direction: VerticalDirection.up,
      onSelected: (customer) =>
          _handleCustomerSelection(customer, dataProvider!),
      itemBuilder: (context, customer) => ListTile(
        title: Text(customer.businessName ?? ''),
        subtitle: Text(customer.registrationId ?? ''),
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
        labelText:
            dataProvider!.selectedCustomer?.businessName ?? 'Search customer',
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
