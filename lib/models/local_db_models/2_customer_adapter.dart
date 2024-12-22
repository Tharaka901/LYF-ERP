import 'package:gsr/models/customer/customer_model.dart';
import 'package:hive/hive.dart';

class CustomerAdapter extends TypeAdapter<CustomerModel> {
  @override
  final typeId = 2;

  @override
  CustomerModel read(BinaryReader reader) {
    return CustomerModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, CustomerModel obj) {
    writer.writeMap(obj.toJson());
  }
}
