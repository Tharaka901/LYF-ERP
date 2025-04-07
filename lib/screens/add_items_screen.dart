import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/added_item.dart';
import 'package:gsr/models/item.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/providers/items_provider.dart';
import 'package:gsr/modules/leak_cylinders/leak_note_screen.dart';
import 'package:gsr/modules/loan_cylinder/loan_note_screen.dart';
import 'package:gsr/modules/return_cylinder/return_note_screen.dart';
import 'package:gsr/modules/invoice/invoice_view.dart';
import 'package:gsr/widgets/add_items.dart';
import 'package:gsr/widgets/cards/add_item_card.dart';
import 'package:gsr/widgets/modify_item.dart';
import 'package:gsr/widgets/option_card.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons/text_toogle.dart';

class AddItemsScreen extends StatefulWidget {
  static const routeId = 'ADD_ITEMS';
  final String? type;
  final bool? isManual;
  const AddItemsScreen({super.key, this.type, this.isManual});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  @override
  void initState() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    itemsProvider.isLoadingItems = true;
    itemsProvider.getBasicItems(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: Consumer<DataProvider>(
        builder: (context, data, _) => data.itemList.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  if (widget.type == 'Loan') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoanNoteScreen(
                                  type: widget.type ?? '',
                                )));
                  } else if (widget.type == 'Leak') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeakNoteScreen(
                                  type: widget.type ?? '',
                                )));
                  } else if (widget.type == 'Return') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReturnNoteScreen(
                                  type: widget.type ?? '',
                                )));
                  } else {
                    Navigator.pushNamed(
                      context,
                      ViewInvoiceScreen.routeId,
                      arguments: {'isManual': widget.isManual},
                    );
                  }
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 40,
                ),
              )
            : dummy,
      ),
      appBar: AppBar(
        title: const Text('Add Items'),
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              dataProvider.itemList.clear();
              dataProvider.selectedCylinderList.clear();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          if (widget.type != 'Default') ...[
            IconButton(
              onPressed: () {
                final quantityController = TextEditingController();
                final quantityControllerLeak = TextEditingController(text: '0');
                final loanTypeController =
                    TextEditingController(text: 'Loan Recive');
                final leakTypeController =
                    TextEditingController(text: 'Leak Recive');
                final cylindserNumberController = TextEditingController();
                final referenceNumberController = TextEditingController();
                final formKey = GlobalKey<FormState>();
                Item? item;
                double? maxQuantity;
                callBack({required Item selectedItem, required double maxQty}) {
                  item = selectedItem;
                  if (selectedItem.hasSpecialPrice != null) {
                    item?.salePrice = selectedItem.hasSpecialPrice!.itemPrice;
                  }
                  item?.cylinderNo = cylindserNumberController.text;
                  item?.referenceNo = referenceNumberController.text;
                  maxQuantity = maxQty;
                }

                confirm(
                  context,
                  title: 'Add Items',
                  body: AddItems(
                    quantityController: widget.type == 'Leak'
                        ? quantityControllerLeak
                        : quantityController,
                    loanItemController: loanTypeController,
                    cylindserNumberController: cylindserNumberController,
                    referenceNumberController: referenceNumberController,
                    leakTypeController: leakTypeController,
                    formKey: formKey,
                    callBack: callBack,
                    type: widget.type,
                  ),
                  onConfirm: () {
                    if (formKey.currentState!.validate()) {
                      if (leakTypeController.text == 'Leak Issue') {
                        if (dataProvider.selectedCylinderList.isNotEmpty &&
                            dataProvider.itemList.isEmpty) {
                          for (var element
                              in dataProvider.selectedCylinderList) {
                            dataProvider.addItem(
                              AddedItem(
                                loanType:
                                    loanTypeController.text == 'Loan Recive'
                                        ? 2
                                        : 3,
                                leakType:
                                    leakTypeController.text == 'Leak Recive'
                                        ? 2
                                        : 3,
                                item: Item(
                                    id: item!.id,
                                    itemRegNo: item!.itemRegNo,
                                    itemName: item!.itemName,
                                    costPrice: item!.costPrice,
                                    salePrice: item!.salePrice,
                                    openingQty: item!.openingQty,
                                    vendorId: item!.vendorId,
                                    priceLevelId: item!.priceLevelId,
                                    itemTypeId: item!.itemTypeId,
                                    stockId: item!.stockId,
                                    costAccId: item!.costAccId,
                                    incomeAccId: item!.incomeAccId,
                                    isNew: item!.isNew,
                                    status: item!.status,
                                    cylinderNo: cylindserNumberController.text,
                                    referenceNo:
                                        referenceNumberController.text),
                                cylinderNo: element.cylinderNo,
                                referenceNo: referenceNumberController.text,
                                quantity: 1,
                                maxQuantity: maxQuantity ??
                                    doub(
                                      quantityControllerLeak.text,
                                    ),
                              ),
                            );
                          }

                          toast('An item added successfully',
                              toastState: TS.success);
                          quantityController.clear();
                          // dataProvider.clearSelectedCylinderList();
                          cylindserNumberController.clear();
                          referenceNumberController.clear();
                          return;
                        }

                        //dataProvider.cylinderList.clear();
                      } else {
                        quantityControllerLeak.text = '1';
                        dataProvider.addItem(
                          AddedItem(
                            loanType: loanTypeController.text == 'Loan Recive'
                                ? 2
                                : 3,
                            leakType: leakTypeController.text == 'Leak Recive'
                                ? 2
                                : 3,
                            item: Item(
                                id: item!.id,
                                itemRegNo: item!.itemRegNo,
                                itemName: item!.itemName,
                                costPrice: item!.costPrice,
                                salePrice: item!.salePrice,
                                openingQty: item!.openingQty,
                                vendorId: item!.vendorId,
                                priceLevelId: item!.priceLevelId,
                                itemTypeId: item!.itemTypeId,
                                stockId: item!.stockId,
                                costAccId: item!.costAccId,
                                incomeAccId: item!.incomeAccId,
                                isNew: item!.isNew,
                                status: item!.status,
                                cylinderNo: cylindserNumberController.text,
                                referenceNo: referenceNumberController.text),
                            cylinderNo: cylindserNumberController.text,
                            referenceNo: referenceNumberController.text,
                            quantity: widget.type == 'Leak'
                                ? doub(quantityControllerLeak.text)
                                : doub(quantityController.text),
                            maxQuantity: maxQuantity ??
                                doub(
                                  quantityController.text,
                                ),
                          ),
                        );
                        cylindserNumberController.clear();
                        referenceNumberController.clear();
                        toast('An item added successfully',
                            toastState: TS.success);
                        quantityController.clear();
                        return;
                      }
                    }
                  },
                  confirmText: 'Add',
                );
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 40.0,
              ),
              splashRadius: 40.0,
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.menu,
                size: 40.0,
              ),
              onSelected: (value) {
                if (value == 1) {
                  confirm(
                    context,
                    title: 'Remove',
                    body: 'Remove all items?',
                    onConfirm: () {
                      dataProvider.clearItemList();
                      pop(context);
                    },
                    confirmText: 'Remove all',
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: dataProvider.itemList.isNotEmpty,
                  value: 1,
                  child: const Text('Remove all items'),
                ),
              ],
            ),
          ]
        ],
      ),
      body: widget.type == 'Default'
          ? SafeArea(
              child: Consumer<ItemsProvider>(builder: (context, ip, _) {
                return ip.isLoadingItems
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(shrinkWrap: true, children: [
                        //! Basic items list
                        const SizedBox(height: 10),
                        ...ip.basicItems.map((e) => AddItemCard(e)),

                        //! New item section
                        ToogleTextButton(
                          label: 'New items',
                          onChanged: ip.onNewItemSwitchPressed,
                        ),
                        if (ip.isViewNewItems)
                          ...ip.newItems.map((e) => AddItemCard(e)),

                        //! Other item section
                        ToogleTextButton(
                          label: 'Other items',
                          onChanged: ip.onOtherItemSwitchPressed,
                        ),
                        if (ip.isViewOtherItems)
                          ...ip.otherItems.map((e) => AddItemCard(e)),
                        const SizedBox(height: 10)
                      ]);
              }),
            )
          : Consumer<DataProvider>(
              builder: (context, data, _) => Padding(
                padding: defaultPadding,
                child: data.itemList.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5.0,
                        ),
                        itemBuilder: (context, index) {
                          final addedItem = data.itemList[index];
                          return Slidable(
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (ctx) => confirm(
                                    ctx,
                                    title: 'Remove ${addedItem.item.itemName}?',
                                    body: null,
                                    onConfirm: () {
                                      data.removeItem(addedItem);
                                      pop(context);
                                    },
                                    confirmText: 'Remove',
                                  ),
                                  backgroundColor: Colors.red,
                                  label: 'Remove',
                                  icon: Icons.delete,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                SlidableAction(
                                  onPressed: (_) {
                                    final quantityController =
                                        TextEditingController();
                                    final formKey = GlobalKey<FormState>();

                                    confirm(
                                      context,
                                      title: 'Modify Item',
                                      body: ModifyItem(
                                        quantityController: quantityController,
                                        formKey: formKey,
                                        addedItem: addedItem,
                                        type: widget.type,
                                      ),
                                      onConfirm: () {
                                        if (formKey.currentState!.validate()) {
                                          dataProvider.modifyItem(
                                            addedItem.modifyAddedItem(
                                                doub(quantityController.text)),
                                          );
                                          toast('Item modified successfully',
                                              toastState: TS.success);
                                          quantityController.clear();
                                          pop(context);
                                          return;
                                        }
                                      },
                                      confirmText: 'Modify',
                                    );
                                  },
                                  backgroundColor: Colors.green.shade700,
                                  label: 'Modify',
                                  icon: Icons.edit,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                              ],
                            ),
                            child: OptionCard(
                              title: Text(
                                addedItem.item.itemName,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              height: 30.0,
                              trailing: Text(
                                numUnit(addedItem.quantity)
                                    .replaceAll(' Qty', ''),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: data.itemList.length,
                      )
                    : const Center(
                        child: Text('No items found'),
                      ),
              ),
            ),
    );
  }
}
