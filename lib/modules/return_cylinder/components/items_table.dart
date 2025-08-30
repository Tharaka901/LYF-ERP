import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gsr/commons/common_methods.dart';
import '../providers/return_cylinder_provider.dart';

class ItemsTable extends StatelessWidget {
  const ItemsTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReturnCylinderProvider>(
      builder: (context, data, _) {
        if (data.selectedItems.isEmpty) {
          return const Center(
            child: Text(
              'No items found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              // Header Row
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                children: [
                  _buildHeaderCell('Item'),
                  _buildHeaderCell('Quantity'),
                  _buildHeaderCell('Action'),
                ],
              ),
              // Data Rows
              ...data.selectedItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return TableRow(
                  children: [
                    _buildDataCell(item.itemName),
                    _buildDataCell(item.itemQty?.toString() ?? '0'),
                    _buildActionCell(context, index, item),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, int index, dynamic item) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _showEditQuantityDialog(context, item),
              icon: const Icon(Icons.edit, color: Colors.blue),
              iconSize: 20,
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                final returnCylinderProvider = Provider.of<ReturnCylinderProvider>(context, listen: false);
                returnCylinderProvider.removeSelectedItem(item);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditQuantityDialog(BuildContext context, dynamic item) {
    final quantityController = TextEditingController(text: item.itemQty?.toString() ?? '0');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Edit Quantity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Item: ${item.itemName}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final returnCylinderProvider = Provider.of<ReturnCylinderProvider>(context, listen: false);
                  item.itemQty = int.parse(quantityController.text);
                  returnCylinderProvider.updateItemQuantity(item);
                  Navigator.of(context).pop();
                  toast('Quantity updated successfully', toastState: TS.success);
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
