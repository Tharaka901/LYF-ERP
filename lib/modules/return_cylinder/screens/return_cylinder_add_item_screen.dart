import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/modules/return_cylinder/screens/return_note_screen.dart';
import '../providers/return_cylinder_provider.dart';
import '../components/add_item_popup.dart';
import '../components/items_table.dart';

class ReturnCylinderAddItemScreen extends StatefulWidget {
  static const routeId = 'RETURN_CYLINDER_ADD_ITEMS';

  const ReturnCylinderAddItemScreen({super.key});

  @override
  State<ReturnCylinderAddItemScreen> createState() =>
      _ReturnCylinderAddItemScreenState();
}

class _ReturnCylinderAddItemScreenState
    extends State<ReturnCylinderAddItemScreen> {
  late ReturnCylinderProvider returnCylinderProvider;
  @override
  void initState() {
    returnCylinderProvider =
        Provider.of<ReturnCylinderProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Items',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            returnCylinderProvider.clearSelectedItems();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddItemDialog(context),
            icon: const Icon(
              Icons.add_rounded,
              size: 40.0,
              color: Colors.white,
            ),
            splashRadius: 40.0,
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              size: 40.0,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 1) {
                _showRemoveAllDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: returnCylinderProvider.selectedItems.isNotEmpty,
                value: 1,
                child: const Text('Remove all items'),
              ),
            ],
          ),
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            ItemsTable(),
          ],
        ),
      ),
      floatingActionButton: Consumer<ReturnCylinderProvider>(
        builder: (context, returnCylinderProvider, _) =>
            returnCylinderProvider.selectedItems.isNotEmpty
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReturnNoteScreen(type: 'Return')));
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddItemPopup();
      },
    );
  }

  void _showRemoveAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove All Items'),
          content: const Text('Are you sure you want to remove all items?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final returnCylinderProvider =
                    Provider.of<ReturnCylinderProvider>(context, listen: false);
                returnCylinderProvider.clearSelectedItems();
                Navigator.of(context).pop();
                toast('All items removed', toastState: TS.success);
              },
              child: const Text(
                'Remove All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
