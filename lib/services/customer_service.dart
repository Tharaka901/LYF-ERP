import '../commons/common_methods.dart';

class CustomerService {
  Future<void> updateCustomer(
      {required int customerId, required double depositBalance}) async {
    await respo(
      'customers/update',
      method: Method.put,
      data: {
        "customerId": customerId,
        "depositBalance": depositBalance,
      },
    );
  }
}
