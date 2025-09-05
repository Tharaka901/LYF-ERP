import 'package:gsr/models/invoice_item/invoice_item_model.dart';
import 'package:hive/hive.dart';

class InvoiceItemAdapter extends TypeAdapter<InvoiceItemModel> {
  @override
  final typeId = 5;

  @override
  InvoiceItemModel read(BinaryReader reader) {
    return InvoiceItemModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, InvoiceItemModel obj) {
    writer.writeMap(obj.toJson());
  }
}
