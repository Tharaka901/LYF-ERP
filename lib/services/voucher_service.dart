import 'package:flutter/material.dart';

import '../commons/common_methods.dart';
import '../models/voucher.dart';

class VoucherService {
  Future<List<VoucherModel>> getVouchers(BuildContext context) async {
    final response = await respo('voucher/all');
    List<dynamic> list = response.data;
    List<VoucherModel> vouchers =
        list.map((e) => VoucherModel.fromJson(e)).toList();
    vouchers.insert(
      0,
      VoucherModel(
        id: 0,
        code: 'None',
        value: 0.0,
      ),
    );
    return vouchers;
  }
}
