import 'package:hive/hive.dart';

class CustomerDepositesAdapter extends TypeAdapter<CustomerDepositsModel> {
  @override
  final typeId = 6;

  @override
  CustomerDepositsModel read(BinaryReader reader) {
    return CustomerDepositsModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, CustomerDepositsModel obj) {
    writer.writeMap(obj.toJson());
  }
}

class CustomerDepositsModel {
  final List<dynamic> deposits;

  CustomerDepositsModel({required this.deposits});

  factory CustomerDepositsModel.fromJson(Map<dynamic, dynamic> json) =>
      CustomerDepositsModel(
        deposits: json["deposits"],
      );

  Map<dynamic, dynamic> toJson() => {"deposits": deposits};
}


