class ReturnCylinderCreditInvoicePaymentRequest {
  final double value;
  final int paymentInvoiceId;
  final int routecardId;
  final int creditInvoiceId;
  final String receiptNo;
  final int status;
  final String type;

  ReturnCylinderCreditInvoicePaymentRequest({
    required this.value,
    required this.paymentInvoiceId,
    required this.routecardId,
    required this.creditInvoiceId,
    required this.receiptNo,
    required this.status,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'paymentInvoiceId': paymentInvoiceId,
      'routecardId': routecardId,
      'creditInvoiceId': creditInvoiceId,
      'receiptNo': receiptNo,
      'status': status,
      'type': type,
    };
  }
}
