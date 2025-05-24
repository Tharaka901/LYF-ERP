import 'package:gsr/models/payment_data/payment_data_model.dart';
import 'package:hive/hive.dart';

class PaymentsAdapter extends TypeAdapter<PaymentDataModel> {
  @override
  final typeId = 8;

  @override
  PaymentDataModel read(BinaryReader reader) {
    return PaymentDataModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, PaymentDataModel obj) {
    writer.writeMap(obj.toJson());
  }
}
