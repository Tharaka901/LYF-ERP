
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

  factory PaymentDataModel.fromJson(Map<dynamic, dynamic> json) {
    return PaymentDataModel(
      selectedCustomer: json['selectedCustomer'],
      totalPayment: json['totalPayment'],
      issuedDepositePaidList: json['issuedDepositePaidList'],
      currentRouteCard: json['currentRouteCard'],
      balance: json['balance'],
      receiptNo: json['receiptNo'],
      cash: json['cash'],
      currentEmployee: json['currentEmployee'],
      chequeList: json['chequeList'] != null
          ? List<ChequeModel>.from(json["chequeList"])
          : [],
      selectedVoucher: json['selectedVoucher'],
      invoiceId: json['invoiceId'],
      issuedInvoicePaidList:
          List<IssuedInvoicePaidModel>.from(json['issuedInvoicePaidList']),
      invoiceNo: json["invoiceNo"],
      isDirectPrevoius: json["isDirectPrevoius"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedCustomer': selectedCustomer,
      'issuedDepositePaidList': issuedDepositePaidList,
      'issuedInvoicePaidList': issuedInvoicePaidList,
      'currentRouteCard': currentRouteCard,
      'balance': balance,
      'receiptNo': receiptNo,
      'totalPayment': totalPayment,
      'cash': cash,
      'currentEmployee': currentEmployee,
      'chequeList': chequeList,
      'selectedVoucher': selectedVoucher,
      'invoiceId': invoiceId,
      'invoiceNo': invoiceNo,
      'isDirectPrevoius': isDirectPrevoius,
    };
  }
}
