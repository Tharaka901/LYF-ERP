
import '../cheque/cheque.dart';
import '../customer/customer_model.dart';
import '../employee/employee_model.dart';
import '../issued_invoice_paid_model/issued_invoice_paid.dart';
import '../route_card/route_card_model.dart';
import '../voucher.dart';

class PaymentDataModel {
  final List<dynamic> issuedDepositePaidList;
  final List<IssuedInvoicePaidModel>? issuedInvoicePaidList;
  final CustomerModel selectedCustomer;
  final RouteCardModel currentRouteCard;
  final double balance;
  final String receiptNo;
  final double cash;
  final EmployeeModel currentEmployee;
  final List<ChequeModel> chequeList;
  final VoucherModel? selectedVoucher;
  final double? totalPayment;
  int? invoiceId;
  String? invoiceNo;
  bool? isDirectPrevoius;

  PaymentDataModel({
    required this.totalPayment,
    required this.selectedCustomer,
    required this.issuedDepositePaidList,
    required this.currentRouteCard,
    this.invoiceId,
    required this.balance,
    required this.receiptNo,
    required this.cash,
    required this.currentEmployee,
    required this.chequeList,
    this.issuedInvoicePaidList,
    this.selectedVoucher,
    this.invoiceNo,
    this.isDirectPrevoius,
  });

  static CustomerModel _parseCustomer(dynamic v) {
    if (v is CustomerModel) return v;
    if (v is Map) return CustomerModel.fromJson(Map<dynamic, dynamic>.from(v));
    throw StateError('selectedCustomer is not CustomerModel or Map');
  }

  static RouteCardModel _parseRouteCard(dynamic v) {
    if (v is RouteCardModel) return v;
    if (v is Map) return RouteCardModel.fromJson(Map<dynamic, dynamic>.from(v));
    throw StateError('currentRouteCard is not RouteCardModel or Map');
  }

  static EmployeeModel _parseEmployee(dynamic v) {
    if (v is EmployeeModel) return v;
    if (v is Map) return EmployeeModel.fromJson(Map<dynamic, dynamic>.from(v));
    throw StateError('currentEmployee is not EmployeeModel or Map');
  }

  static double _parseDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0.0;
  }

  factory PaymentDataModel.fromJson(Map<dynamic, dynamic> json) {
    return PaymentDataModel(
      selectedCustomer: _parseCustomer(json['selectedCustomer']),
      totalPayment: _parseDouble(json['totalPayment']),
      issuedDepositePaidList: json['issuedDepositePaidList'] is List
          ? (json['issuedDepositePaidList'] as List)
          : [],
      currentRouteCard: _parseRouteCard(json['currentRouteCard']),
      balance: _parseDouble(json['balance']),
      receiptNo: json['receiptNo']?.toString() ?? '',
      cash: _parseDouble(json['cash']),
      currentEmployee: _parseEmployee(json['currentEmployee']),
      chequeList: json['chequeList'] != null && json['chequeList'] is List
          ? (json['chequeList'] as List)
              .map((x) => x is ChequeModel
                  ? x
                  : ChequeModel.fromJson(Map<dynamic, dynamic>.from(x as Map)))
              .toList()
          : [],
      selectedVoucher: json['selectedVoucher'] == null
          ? null
          : (json['selectedVoucher'] is VoucherModel
              ? json['selectedVoucher'] as VoucherModel
              : VoucherModel.fromJson(
                  Map<String, dynamic>.from(json['selectedVoucher'] as Map))),
      invoiceId: json['invoiceId'],
      issuedInvoicePaidList: json['issuedInvoicePaidList'] != null &&
              json['issuedInvoicePaidList'] is List
          ? List<IssuedInvoicePaidModel>.from(
              (json['issuedInvoicePaidList'] as List).map((x) {
                if (x is IssuedInvoicePaidModel) return x;
                if (x is Map) {
                  return IssuedInvoicePaidModel.fromJson(
                      Map<dynamic, dynamic>.from(x));
                }
                return IssuedInvoicePaidModel.fromJson(
                    Map<String, dynamic>.from(x as Map));
              }))
          : null,
      invoiceNo: json['invoiceNo']?.toString(),
      isDirectPrevoius: json['isDirectPrevoius'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedCustomer': selectedCustomer.toJson(),
      'issuedDepositePaidList': issuedDepositePaidList,
      'issuedInvoicePaidList':
          issuedInvoicePaidList?.map((e) => e.toJson()).toList(),
      'currentRouteCard': currentRouteCard.toJson(),
      'balance': balance,
      'receiptNo': receiptNo,
      'totalPayment': totalPayment,
      'cash': cash,
      'currentEmployee': currentEmployee.toJson(),
      'chequeList': chequeList.map((e) => e.toJson()).toList(),
      'selectedVoucher': selectedVoucher?.toJson(),
      'invoiceId': invoiceId,
      'invoiceNo': invoiceNo,
      'isDirectPrevoius': isDirectPrevoius,
    };
  }
}
