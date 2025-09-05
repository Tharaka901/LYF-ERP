import 'package:gsr/models/item/item_model.dart';

class AddedItem {
  final ItemModel item;
  double quantity;
  final double maxQuantity;
  final int? loanType;
  final int? leakType;
  final String? cylinderNo;
  final String? referenceNo;
  final int? id;

  AddedItem({
    required this.item,
    required this.quantity,
    required this.maxQuantity,
    this.loanType,
    this.leakType,
    this.cylinderNo,
    this.referenceNo,
    this.id,
  });

  AddedItem modifyAddedItem(double quantity) => AddedItem(
      item: item,
      quantity: quantity,
      maxQuantity: maxQuantity,
      loanType: loanType,
      leakType: leakType);
}
