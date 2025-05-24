import 'package:gsr/models/invoice/invoice_model.dart';
import 'package:hive/hive.dart';

class InvoiceAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final typeId = 4;

  @override
  InvoiceModel read(BinaryReader reader) {
    return InvoiceModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer.writeMap(obj.toJsonWithId());
  }
}
