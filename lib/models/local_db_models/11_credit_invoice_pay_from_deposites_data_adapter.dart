import 'package:hive/hive.dart';

import '../credit_invoice_pay_from_diposites/credit_invoice_pay_from_diposites_data_model.dart';

class CreditInvoicePayFromDepositesDataAdapter
    extends TypeAdapter<CreditInvoicePayFromDipositesDataModel> {
  @override
  final typeId = 11;

  @override
  CreditInvoicePayFromDipositesDataModel read(BinaryReader reader) {
    return CreditInvoicePayFromDipositesDataModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, CreditInvoicePayFromDipositesDataModel obj) {
    writer.writeMap(obj.toJson());
  }
}
