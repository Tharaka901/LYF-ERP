import 'package:flutter/material.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/added_item.dart';

class ModifyItem extends StatefulWidget {
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKey;
  final AddedItem addedItem;
  const ModifyItem({
    Key? key,
    required this.quantityController,
    required this.formKey,
    required this.addedItem,
  }) : super(key: key);

  @override
  State<ModifyItem> createState() => _ModifyItemState();
}

class _ModifyItemState extends State<ModifyItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.addedItem.item.itemName),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: widget.quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Quantity',
                  prefixText: '${num(widget.addedItem.quantity)} to '),
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return 'Quantity cannot be empty!';
                } else if (doub(text) <= 0) {
                  return 'Invalid quantity!';
                } else if (doub(text) > widget.addedItem.maxQuantity) {
                  return 'Quantity exceeded (${num(widget.addedItem.maxQuantity)})';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
