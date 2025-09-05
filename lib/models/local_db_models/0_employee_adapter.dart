import 'package:gsr/models/employee/employee_model.dart';
import 'package:hive_flutter/adapters.dart';

class EmployeeAdapter extends TypeAdapter<EmployeeModel> {
  @override
  final typeId = 0;

  @override
  EmployeeModel read(BinaryReader reader) {
    return EmployeeModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, EmployeeModel obj) {
    writer.writeMap(obj.toJson());
  }
}
