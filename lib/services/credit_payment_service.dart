import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/model/request/credit_payment_request.dart';

class CreditPaymentService {
  static Future<void> createCreditPayment(
      ReturnCylinderCreditInvoicePaymentRequest request) async {
    await respo('credit-payment/create',
        method: Method.post, data: request.toJson());
  }
}