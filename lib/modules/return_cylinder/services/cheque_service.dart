import 'package:gsr/commons/common_methods.dart';

class ChequeService {
  static Future<void> updateChequeStatus({
    required int chequeId,
    required int status,
    required double balance,
  }) async {
    await respo('cheque/update',
        method: Method.put,
        data: {"id": chequeId, "isActive": status, "balance": balance});
  }
}
