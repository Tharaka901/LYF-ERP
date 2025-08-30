import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/item/item_model.dart';
import 'package:gsr/providers/data_provider.dart';
import '../providers/return_cylinder_provider.dart';
import 'package:gsr/services/item_service.dart';

class AddItemPopup extends StatefulWidget {
  const AddItemPopup({
    super.key,
  });

  @override
  State<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  final quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ItemModel? selectedItem;

  void selectItem({required ItemModel item}) {
    selectedItem = item;
    if (item.hasSpecialPrice != null) {
      selectedItem?.salePrice = item.hasSpecialPrice!.itemPrice;
    }
  }

  void addItem() {
    if (formKey.currentState!.validate() && selectedItem != null) {
      final returnCylinderProvider =
          Provider.of<ReturnCylinderProvider>(context, listen: false);
      selectedItem!.itemQty = int.parse(quantityController.text);
      returnCylinderProvider.addSelectedItem(selectedItem!);
      toast('Item added successfully', toastState: TS.success);
      quantityController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Add Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Form
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Item Selection Dropdown
                  FutureBuilder<List<ItemModel>>(
                    future: ItemService.getReturnCylinderItems(
                        Provider.of<DataProvider>(context, listen: false)
                            .selectedCustomer!
                            .priceLevelId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Text('Error loading items');
                      }

                      final items = snapshot.data ?? [];

                      if (items.isEmpty) {
                        return const Text('No items available');
                      }

                      return DropdownButtonFormField<ItemModel>(
                        decoration: const InputDecoration(
                          labelText: 'Select item',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: items.map((item) {
                          return DropdownMenuItem<ItemModel>(
                            value: item,
                            child: Text(
                              item.itemName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (item) {
                          if (item != null) {
                            selectItem(
                              item: item,
                            );
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an item';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  // Quantity Input
                  TextFormField(
                    controller: quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Quantity cannot be empty!';
                      } else if (doub(text) <= 0) {
                        return 'Invalid quantity!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      addItem();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }
}
