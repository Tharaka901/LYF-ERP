import 'package:gsr/models/customer_deposite.dart';

import '../invoice/invoice_model.dart';

class IssuedInvoicePaidModel {
  final InvoiceModel issuedInvoice;
  final double paymentAmount;
  final double? creditAmount;
  final int? chequeId;
  final int? invoiceId;

  IssuedInvoicePaidModel({
    required this.issuedInvoice,
    required this.paymentAmount,
    this.creditAmount,
    this.chequeId,
    this.invoiceId,
  });

  factory IssuedInvoicePaidModel.fromJson(Map<dynamic, dynamic> json) {
    final issuedInvoiceJson = json['issuedInvoice'];
    final InvoiceModel issuedInvoice = issuedInvoiceJson is Map
        ? InvoiceModel.fromJson(Map<dynamic, dynamic>.from(issuedInvoiceJson))
        : InvoiceModel.fromJson(json['issuedInvoice'] as Map<dynamic, dynamic>);
    final paymentAmount = json['paymentAmount'];
    final num? paymentAmountNum =
        paymentAmount is int ? paymentAmount.toDouble() : paymentAmount as num?;
    final creditAmount = json['creditAmount'];
    final double? creditAmountVal = creditAmount == null
        ? null
        : (creditAmount is int ? creditAmount.toDouble() : (creditAmount as num?)?.toDouble());
    return IssuedInvoicePaidModel(
        issuedInvoice: issuedInvoice,
        paymentAmount: paymentAmountNum?.toDouble() ?? 0.0,
        creditAmount: creditAmountVal,
        chequeId: json['chequeId'],
        invoiceId: json['invoiceId']);
  }

  Map<dynamic, dynamic> toJson() {
    // Use toJsonWithId() so credit invoice invoiceId is persisted for sync-to-live-DB
    final Map<dynamic, dynamic> data = {
      'issuedInvoice': issuedInvoice.toJsonWithId(),
      'paymentAmount': paymentAmount,
    };
    if (creditAmount != null) data['creditAmount'] = creditAmount;
    if (chequeId != null) data['chequeId'] = chequeId;
    if (invoiceId != null) data['invoiceId'] = invoiceId;
    return data;
  }
}

class IssuedDepositePaidModel {
  final CustomerDeposite issuedDeposite;
  final double paymentAmount;
  final double? depositeValue;

  IssuedDepositePaidModel({
    required this.issuedDeposite,
    required this.paymentAmount,
    this.depositeValue,
  });
}
