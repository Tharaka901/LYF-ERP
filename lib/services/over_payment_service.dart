import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/model/request/over_payment_request.dart';

class OverPaymentService {
  static Future<void> createOverPayment(
      ReturnCylinderOverPaymentRequest request) async {
    try {
      await respo('over-payment/create',
          method: Method.post, data: request.toJson());
    } catch (e) {
      toast(e.toString());
      rethrow;
    }
  }
}