import 'package:gsr/models/customer_deposite.dart';
import 'package:gsr/models/issued_invoice.dart';

class IssuedInvoicePaid {
  final IssuedInvoice issuedInvoice;
  final double paymentAmount;
  final double? creditAmount;
  final int? chequeId;

  IssuedInvoicePaid(
      {required this.issuedInvoice,
      required this.paymentAmount,
      this.creditAmount,
      this.chequeId});
}

class IssuedDepositePaid {
  final CustomerDeposite issuedDeposite;
  final double paymentAmount;
  final double? depositeValue;
  final int? status;

  IssuedDepositePaid({
    required this.issuedDeposite,
    required this.paymentAmount,
    this.depositeValue,
    this.status,
  });
}
