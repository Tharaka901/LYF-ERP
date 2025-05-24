import 'package:gsr/models/cheque/cheque.dart';
import 'package:hive/hive.dart';

class ChequeAdapter extends TypeAdapter<ChequeModel> {
  @override
  final typeId = 10;

  @override
  ChequeModel read(BinaryReader reader) {
    return ChequeModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, ChequeModel obj) {
    writer.writeMap(obj.toJson());
  }
}
