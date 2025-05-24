import 'package:hive_flutter/hive_flutter.dart';

import '../customer_deposite.dart';

class CustomerDepositeAdapter extends TypeAdapter<CustomerDeposite> {
  @override
  final typeId = 7;

  @override
  CustomerDeposite read(BinaryReader reader) {
    return CustomerDeposite.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, CustomerDeposite obj) {
    writer.writeMap(obj.toJson());
  }
}
