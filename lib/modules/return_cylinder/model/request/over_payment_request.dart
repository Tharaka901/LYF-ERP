class ReturnCylinderOverPaymentRequest {
  final String value;
  final int status;
  final int paymentInvoiceId;
  final int routecardId;
  final String receiptNo;
  final int customerId;

  ReturnCylinderOverPaymentRequest({
    required this.value,
    required this.status,
    required this.paymentInvoiceId,
    required this.routecardId,
    required this.receiptNo,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'status': status,
      'paymentInvoiceId': paymentInvoiceId,
      'routecardId': routecardId,
      'receiptNo': receiptNo,
      'customerId': customerId,
    };
  }
}
