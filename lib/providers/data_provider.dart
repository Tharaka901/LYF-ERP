import 'package:flutter/widgets.dart';
import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/cheque/cheque.dart';
import 'package:gsr/models/customer_deposite.dart';
import 'package:gsr/models/issued_invoice_paid_model/issued_invoice_paid.dart';
import 'package:gsr/models/paid_balance.dart';
import 'package:gsr/models/route_card/route_card_model.dart';
import 'package:gsr/models/voucher.dart';

import '../models/customer/customer_model.dart';
import '../models/cylinder.dart';
import '../models/employee/employee_model.dart';
import '../models/invoice/invoice_model.dart';
import '../models/route_card_item/route_card_item_model.dart';
import '../services/database.dart';

class DataProvider extends ChangeNotifier {
  EmployeeModel? _currentEmployee;
  RouteCardModel? _currentRouteCard;
  CustomerModel? _selectedCustomer;
  InvoiceModel? _selectedInvoice;
  final _itemList = <AddedItem>[];
  final _chequeList = <ChequeModel>[];
  final _rcItemList = <RouteCardItemModel>[];
  final _paidBalanceList = <PaidBalance>[];
  final _issuedInvoicePaidList = <IssuedInvoicePaidModel>[];
  List<IssuedDepositePaidModel> issuedDepositePaidList = <IssuedDepositePaidModel>[];
  InvoiceModel? _currentInvoice;
  CustomerDeposite? selectedDeposite;
  VoucherModel? _selectedVoucher;
  List<Cylinder> cylinderList = [];
  List<Cylinder> selectedCylinderList = [];
  List<int> selectedCylinderItemIds = [];
  bool isManualReceipt = false;

  EmployeeModel? get currentEmployee => _currentEmployee;
  RouteCardModel? get currentRouteCard => _currentRouteCard;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  InvoiceModel? get currentInvoice => _currentInvoice;
  VoucherModel? get selectedVoucher => _selectedVoucher;
  InvoiceModel? get selectedInvoice => _selectedInvoice;
  List<AddedItem> get itemList => _itemList;
  List<ChequeModel> get chequeList => _chequeList;
  List<RouteCardItemModel> get rcItemList => _rcItemList;
  List<PaidBalance> get paidBalanceList => _paidBalanceList;
  List<IssuedInvoicePaidModel> get issuedInvoicePaidList => _issuedInvoicePaidList;

  //! Calculate total amount of non-VAT items
  double get nonVatItemTotal => itemList.isEmpty
      ? 0
      : itemList
          .map((e) => e.item.nonVatAmount ?? 0 * e.quantity)
          .reduce((value, element) => value + element);

  //! Calculate total amount of VAT
  double get vat => double.parse(((getTotalAmount() / 100) *
          double.parse(selectedCustomer!.vat?.vatAmount ?? '0'))
      .toStringAsFixed(2));

  //! Calculate total amount of items
  double getTotalAmount() {
    if (_itemList.isEmpty) return 0.0;

    return _itemList.fold(0.0, (total, addedItem) {
      final price =
          addedItem.item.hasSpecialPrice?.itemPrice ?? addedItem.item.salePrice;
      return total + (price * addedItem.quantity);
    });
  }

  //! Calculate grand total
  double get grandTotal => double.parse(
      (getTotalAmount() + vat + nonVatItemTotal).toStringAsFixed(2));

  //! Calculate total payment amount

  setCurrentEmployee(EmployeeModel currentEmployee) {
    _currentEmployee = currentEmployee;
    notifyListeners();
  }

  setCurrentRouteCard(RouteCardModel currentRouteCard) {
    _currentRouteCard = currentRouteCard;
    notifyListeners();
  }

  setCurrentInvoice(InvoiceModel? currentInvoice) {
    _currentInvoice = currentInvoice;
  }

  setSelectedCustomer(CustomerModel? selectedCustomer) {
    _selectedCustomer = selectedCustomer;
    notifyListeners();
  }

  setSelectedInvoice(InvoiceModel? selectedInvoice) {
    _selectedInvoice = selectedInvoice;
    //notifyListeners();
  }

  setSelectedDeposite(CustomerDeposite? selectedDeposite1) {
    selectedDeposite = selectedDeposite1;
    notifyListeners();
  }

  setSelectedVoucher(VoucherModel? selectedVoucher) {
    _selectedVoucher = selectedVoucher;
  }

  acceptRouteCard() {
    _currentRouteCard = _currentRouteCard!.acceptedRouteCard();
    notifyListeners();
  }

  rejectRouteCard() {
    _currentRouteCard = _currentRouteCard!.rejectedRouteCard();
    notifyListeners();
  }

  addItem(AddedItem item) {
    _itemList.add(item);
    notifyListeners();
  }

  addPaidDeposite(IssuedDepositePaidModel issuedDepositePaid) {
    issuedDepositePaidList.add(issuedDepositePaid);
    notifyListeners();
  }

  addPaidIssuedInvoice(IssuedInvoicePaidModel issuedInvoicePaid) {
    _issuedInvoicePaidList.add(issuedInvoicePaid);
    notifyListeners();
  }

  addPaidBalance(PaidBalance paidBalance) {
    _paidBalanceList.add(paidBalance);
    notifyListeners();
  }

  addRCItem(RouteCardItemModel rcItem) {
    _rcItemList.add(rcItem);
  }

  clearRCItems() {
    _rcItemList.clear();
  }

  clearPreviousInvoiceList() {
    _issuedInvoicePaidList.clear();
    notifyListeners();
  }

  addCheque(ChequeModel cheque) {
    _chequeList.add(cheque);
    notifyListeners();
  }

  clearChequeList() {
    _chequeList.clear();
  }

  removeCheque(ChequeModel cheque) {
    _chequeList
        .removeWhere((element) => element.chequeNumber == cheque.chequeNumber);
    notifyListeners();
  }

  removePaidIssuedInvoice(IssuedInvoicePaidModel issuedInvoicePaid) {
    _issuedInvoicePaidList.removeWhere(
      (element) =>
          element.issuedInvoice.invoiceId ==
          issuedInvoicePaid.issuedInvoice.invoiceId,
    );
    notifyListeners();
  }

  removePaidDepositeInvoice(IssuedDepositePaidModel issuedDepositePaid) {
    issuedDepositePaidList.removeWhere(
      (element) =>
          element.issuedDeposite.paymentInvoiceId ==
          issuedDepositePaid.issuedDeposite.paymentInvoiceId,
    );
    notifyListeners();
  }

  removePaidBalance(PaidBalance paidBalance) {
    _paidBalanceList.removeWhere((element) =>
        element.balance.invoice.customerBalanceId ==
        paidBalance.balance.customerBalanceId);
    notifyListeners();
  }

  clearPaidBalanceList() {
    _paidBalanceList.clear();
  }

  modifyItem(AddedItem item, double newQuantity) {
    // removeItem(item);
    // addItem(item);
    item.quantity = newQuantity;
    notifyListeners();
  }

  removeItem(AddedItem item) {
    _itemList.removeWhere((element) =>
        element.item.id == item.item.id &&
        element.cylinderNo == item.cylinderNo);
    notifyListeners();
  }

  getTotalCreditPaymentAmount() {
    double totalAmount = 0.0;
    for (var paidBalance in _paidBalanceList) {
      totalAmount += paidBalance.payment;
    }
    return totalAmount;
  }

  double getTotalInvoicePaymentAmount() {
    if (_issuedInvoicePaidList.isEmpty) return 0.0;

    return _issuedInvoicePaidList
        .map((payment) => payment.paymentAmount)
        .reduce((sum, amount) => sum + amount)
        .toDouble();
  }

  double getTotalDepositePaymentAmount() {
    double totalAmount = 0.0;
    for (var paidBalance in issuedDepositePaidList) {
      totalAmount += paidBalance.paymentAmount;
    }
    return totalAmount;
  }

  getTotalChequeAmount() {
    double totalAmount = 0.0;
    for (var cheque in _chequeList) {
      totalAmount += cheque.chequeAmount;
    }
    return totalAmount;
  }

  clearItemList() {
    _itemList.clear();
    notifyListeners();
  }

  getCylindersByItem(int customerId, int itemId) async {
    notifyListeners();
    cylinderList = [];
    final cylinders = await getCylindersByItemId(customerId, itemId);
    cylinderList = cylinders;
    notifyListeners();
  }

  addCylinder(Cylinder cylinder) {
    selectedCylinderList.add(cylinder);
  }

  selectCylinder() {
    notifyListeners();
  }

  clearSelectedCylinderList() {
    selectedCylinderList = [];
    cylinderList = [];
    notifyListeners();
  }

  setManualReceipt(bool value) {
    isManualReceipt = value;
    notifyListeners();
  }
}
