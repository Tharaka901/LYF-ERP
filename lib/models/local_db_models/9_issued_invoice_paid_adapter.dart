import 'package:hive/hive.dart';

import '../issued_invoice_paid_model/issued_invoice_paid.dart';

class IssuedInvoicePaidAdapter extends TypeAdapter<IssuedInvoicePaidModel> {
  @override
  final typeId = 9;

  @override
  IssuedInvoicePaidModel read(BinaryReader reader) {
    return IssuedInvoicePaidModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, IssuedInvoicePaidModel obj) {
    writer.writeMap(obj.toJson());
  }
}
