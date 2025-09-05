class CreditInvoicePayFromDipositesDataModel {
  final double depositeValue;
  final double payValue;
  final int customerId;
  final int paymentInvoiceId;
  final String? depositeReceiptNo;
  double customerDepositeValue;
  final int depositeStatus;
  final int depositeId;
  final int routeCardId;
  final int? chequeId;
  final int creditInvoiceId;
  final String depositeCreatedDate;
  final double crediteInvoiceValue;

  CreditInvoicePayFromDipositesDataModel({
    required this.depositeValue,
    required this.payValue,
    required this.customerId,
    required this.paymentInvoiceId,
    this.depositeReceiptNo,
    required this.customerDepositeValue,
    required this.depositeStatus,
    required this.depositeId,
    required this.routeCardId,
    this.chequeId,
    required this.creditInvoiceId,
    required this.depositeCreatedDate,
    required this.crediteInvoiceValue,
  });

  // fromJson method
  factory CreditInvoicePayFromDipositesDataModel.fromJson(
      Map<dynamic, dynamic> json) {
    return CreditInvoicePayFromDipositesDataModel(
        depositeValue: json['depositeValue'],
        payValue: json['payValue'],
        customerId: json['customerId'],
        paymentInvoiceId: json['paymentInvoiceId'],
        depositeReceiptNo: json['depositeReceiptNo'],
        customerDepositeValue: json['customerDepositeValue'],
        depositeStatus: json['depositeStatus'],
        depositeId: json['depositeId'],
        routeCardId: json['routeCardId'],
        chequeId: json['chequeId'],
        creditInvoiceId: json['creditInvoiceId'],
        depositeCreatedDate: json['depositeCreatedDate'],
        crediteInvoiceValue: json['crediteInvoiceValue']);
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'depositeValue': depositeValue,
      'payValue': payValue,
      'customerId': customerId,
      'paymentInvoiceId': paymentInvoiceId,
      'depositeReceiptNo': depositeReceiptNo,
      'customerDepositeValue': customerDepositeValue,
      'depositeStatus': depositeStatus,
      'depositeId': depositeId,
      'routeCardId': routeCardId,
      'chequeId': chequeId,
      'creditInvoiceId': creditInvoiceId,
      'depositeCreatedDate': depositeCreatedDate,
      'crediteInvoiceValue': crediteInvoiceValue,
    };
  }
}
