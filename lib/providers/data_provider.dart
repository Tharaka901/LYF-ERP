import 'package:flutter/widgets.dart';
import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/cheque.dart';
import 'package:gsr/models/customer.dart';
import 'package:gsr/models/customer_deposite.dart';
import 'package:gsr/models/employee.dart';
import 'package:gsr/models/invoice.dart';
import 'package:gsr/models/issued_invoice.dart';
import 'package:gsr/models/issued_invoice_paid.dart';
import 'package:gsr/models/paid_balance.dart';
import 'package:gsr/models/route_card.dart';
import 'package:gsr/models/routecard_item.dart';
import 'package:gsr/models/voucher.dart';

import '../models/customer/customer_model.dart';
import '../models/cylinder.dart';
import '../services/database.dart';

class DataProvider extends ChangeNotifier {
  Employee? _currentEmployee;
  RouteCard? _currentRouteCard;
  CustomerModel? _selectedCustomer;
  IssuedInvoice? _selectedInvoice;
  final _itemList = <AddedItem>[];
  final _chequeList = <Cheque>[];
  final _rcItemList = <RoutecardItem>[];
  final _paidBalanceList = <PaidBalance>[];
  final _issuedInvoicePaidList = <IssuedInvoicePaid>[];
  List<IssuedDepositePaid> issuedDepositePaidList = <IssuedDepositePaid>[];
  Invoice? _currentInvoice;
  CustomerDeposite? selectedDeposite;
  Voucher? _selectedVoucher;
  List<Cylinder> cylinderList = [];
  List<Cylinder> selectedCylinderList = [];
  List<int> selectedCylinderItemIds = [];
  bool isManualReceipt = false;

  Employee? get currentEmployee => _currentEmployee;
  RouteCard? get currentRouteCard => _currentRouteCard;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  Invoice? get currentInvoice => _currentInvoice;
  Voucher? get selectedVoucher => _selectedVoucher;
  IssuedInvoice? get selectedInvoice => _selectedInvoice;
  List<AddedItem> get itemList => _itemList;
  List<Cheque> get chequeList => _chequeList;
  List<RoutecardItem> get rcItemList => _rcItemList;
  List<PaidBalance> get paidBalanceList => _paidBalanceList;
  List<IssuedInvoicePaid> get issuedInvoicePaidList => _issuedInvoicePaidList;
  double get nonVatItemTotal => itemList.isEmpty
      ? 0
      : itemList
          .map((e) => e.item.nonVatAmount ?? 0 * e.quantity)
          .reduce((value, element) => value + element);

  double get vat => double.parse(((getTotalAmount() / 100) *
          double.parse(selectedCustomer!.vat!.vatAmount))
      .toStringAsFixed(2));
  double get grandTotal => double.parse(
      (getTotalAmount() + vat + nonVatItemTotal).toStringAsFixed(2));

  setCurrentEmployee(Employee currentEmployee) {
    _currentEmployee = currentEmployee;
    notifyListeners();
  }

  setCurrentRouteCard(RouteCard currentRouteCard) {
    _currentRouteCard = currentRouteCard;
    notifyListeners();
  }

  setCurrentInvoice(Invoice? currentInvoice) {
    _currentInvoice = currentInvoice;
  }

  setSelectedCustomer(CustomerModel? selectedCustomer) {
    _selectedCustomer = selectedCustomer;
    notifyListeners();
  }

  setSelectedInvoice(IssuedInvoice? selectedInvoice) {
    _selectedInvoice = selectedInvoice;
    //notifyListeners();
  }

  setSelectedDeposite(CustomerDeposite? selectedDeposite1) {
    selectedDeposite = selectedDeposite1;
    notifyListeners();
  }

  setSelectedVoucher(Voucher? selectedVoucher) {
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

  addPaidDeposite(IssuedDepositePaid issuedDepositePaid) {
    issuedDepositePaidList.add(issuedDepositePaid);
    notifyListeners();
  }

  addPaidIssuedInvoice(IssuedInvoicePaid issuedInvoicePaid) {
    _issuedInvoicePaidList.add(issuedInvoicePaid);
    notifyListeners();
  }

  addPaidBalance(PaidBalance paidBalance) {
    _paidBalanceList.add(paidBalance);
    notifyListeners();
  }

  addRCItem(RoutecardItem rcItem) {
    _rcItemList.add(rcItem);
  }

  clearRCItems() {
    _rcItemList.clear();
  }

  clearPreviousInvoiceList() {
    _issuedInvoicePaidList.clear();
    notifyListeners();
  }

  addCheque(Cheque cheque) {
    _chequeList.add(cheque);
    notifyListeners();
  }

  clearChequeList() {
    _chequeList.clear();
  }

  removeCheque(Cheque cheque) {
    _chequeList
        .removeWhere((element) => element.chequeNumber == cheque.chequeNumber);
    notifyListeners();
  }

  removePaidIssuedInvoice(IssuedInvoicePaid issuedInvoicePaid) {
    _issuedInvoicePaidList.removeWhere(
      (element) =>
          element.issuedInvoice.invoiceId ==
          issuedInvoicePaid.issuedInvoice.invoiceId,
    );
    notifyListeners();
  }

  removePaidDepositeInvoice(IssuedDepositePaid issuedDepositePaid) {
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

  modifyItem(AddedItem item) {
    removeItem(item);
    addItem(item);
    notifyListeners();
  }

  removeItem(AddedItem item) {
    _itemList.removeWhere((element) => element.item.id == item.item.id);
    notifyListeners();
  }

  double getTotalAmount() {
    double totalAmount = 0.0;
    for (var addedItem in _itemList) {
      totalAmount += (addedItem.item.hasSpecialPrice != null
              ? addedItem.item.hasSpecialPrice!.itemPrice
              : addedItem.item.salePrice) *
          addedItem.quantity;
    }
    return totalAmount;
  }

  getTotalCreditPaymentAmount() {
    double totalAmount = 0.0;
    for (var paidBalance in _paidBalanceList) {
      totalAmount += paidBalance.payment;
    }
    return totalAmount;
  }

  getTotalInvoicePaymentAmount() {
    double totalAmount = 0.0;
    for (var paidBalance in _issuedInvoicePaidList) {
      totalAmount += paidBalance.paymentAmount;
    }
    return totalAmount;
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
