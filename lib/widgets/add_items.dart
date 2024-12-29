import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';
import 'package:gsr/models/item.dart';
import 'package:gsr/models/routecard_item.dart';
import 'package:gsr/providers/data_provider.dart';
import 'package:gsr/services/database.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  final TextEditingController quantityController;
  final TextEditingController loanItemController;
  final TextEditingController cylindserNumberController;
  final TextEditingController referenceNumberController;
  final TextEditingController leakTypeController;
  final GlobalKey<FormState> formKey;
  final String? type;
  final void Function({required Item selectedItem, required double maxQty})
      callBack;
  const AddItems({
    Key? key,
    required this.quantityController,
    required this.loanItemController,
    required this.formKey,
    required this.callBack,
    this.type,
    required this.cylindserNumberController,
    required this.referenceNumberController,
    required this.leakTypeController,
  }) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final quantityFocus = FocusNode();
  bool _switchValue = false;
  RoutecardItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final routeCard = dataProvider.currentRouteCard!;
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.type == 'Default')
              Row(
                children: [
                  Switch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                  const Text(
                    'New item',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            const SizedBox(
              height: 10.0,
            ),
            if (widget.type == 'Leak')
              Consumer<DataProvider>(builder: (context, _, __) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Select Issued/Recived',
                  ),
                  style: defaultTextFieldStyle,
                  value: 'Leak Recive',
                  items: ['Leak Recive', 'Leak Issue'].map((element) {
                    return DropdownMenuItem(
                      value: element,
                      child: Text(element),
                    );
                  }).toList(),
                  onChanged: dataProvider.itemList.isEmpty
                      ? (item) {
                          widget.leakTypeController.text = item!;
                          setState(() {});
                        }
                      : null,
                );
              }),
            const SizedBox(
              height: 10.0,
            ),
            if (widget.type == 'Loan')
              FutureBuilder<List<RoutecardItem>>(
                future: getLoanItems(routeCard.routeCardId),
                builder:
                    (context, AsyncSnapshot<List<RoutecardItem>> snapshot) {
                  if (snapshot.hasData && snapshot.data![0].item != null) {
                    final routecardItem = snapshot.data![0];
                    widget.callBack(
                      selectedItem: routecardItem.item!,
                      maxQty: routecardItem.transferQty - routecardItem.sellQty,
                    );
                    selectedItem = routecardItem;
                  }
                  return DropdownButtonFormField<RoutecardItem>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText:
                          snapshot.connectionState == ConnectionState.waiting
                              ? 'Loading...'
                              : (snapshot.hasData ? 'Select item' : 'No items'),
                    ),
                    style: defaultTextFieldStyle,
                    value: snapshot.hasData ? snapshot.data![0] : null,
                    validator: (value) {
                      if (value == null) {
                        return 'Select an item!';
                      } else if (dataProvider.itemList
                          .where((element) => element.item.id == value.item!.id)
                          .isNotEmpty) {
                        return 'Already added!';
                      }
                      return null;
                    },
                    items: snapshot.hasData
                        ? snapshot.data!.toList().map((element) {
                            final item = element.item ?? dummyItem;
                            return DropdownMenuItem(
                              value: element,
                              child: Text(item.itemName),
                            );
                          }).toList()
                        : [],
                    onChanged: (item) {
                      if (item != null) {
                        widget.callBack(
                          selectedItem: item.item!,
                          maxQty: item.transferQty - item.sellQty,
                        );
                        selectedItem = item;
                        quantityFocus.requestFocus();
                      }
                    },
                  );
                },
              ),
            if (widget.type == 'Leak')
              FutureBuilder<List<RoutecardItem>>(
                future: widget.leakTypeController.text != 'Leak Recive'
                    ? getLeakIssueItems(
                        dataProvider.currentRouteCard!.routeCardId,
                        dataProvider.selectedCustomer!.customerId!)
                    : getLoanItems(routeCard.routeCardId,
                        status: widget.leakTypeController.text == 'Leak Recive'
                            ? 6
                            : 7),
                builder:
                    (context, AsyncSnapshot<List<RoutecardItem>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      if (snapshot.hasData && snapshot.data?[0].item != null) {
                        final routecardItem = snapshot.data![0];
                        widget.callBack(
                          selectedItem: routecardItem.item!,
                          maxQty:
                              routecardItem.transferQty - routecardItem.sellQty,
                        );
                        selectedItem = routecardItem;
                      }
                    }
                  }
                  return DropdownButtonFormField<RoutecardItem>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText:
                          snapshot.connectionState == ConnectionState.waiting
                              ? 'Loading...'
                              : (snapshot.hasData ? 'Select item' : 'No items'),
                    ),
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                    ),
                    value: snapshot.hasData && snapshot.data!.isNotEmpty
                        ? snapshot.data![0]
                        : null,
                    validator: (value) {
                      if (value == null) {
                        return 'Select an item!';
                      }
                      return null;
                    },
                    items: snapshot.hasData && snapshot.data!.isNotEmpty
                        ? snapshot.data!.toList().map((element) {
                            final item = element.item ?? dummyItem;
                            return DropdownMenuItem(
                              value: element,
                              child: Text(item.itemName),
                            );
                          }).toList()
                        : [],
                    onChanged: (item) {
                      if (item != null) {
                        widget.callBack(
                          selectedItem: item.item!,
                          maxQty: item.transferQty - item.sellQty,
                        );
                        selectedItem = item;
                        quantityFocus.requestFocus();
                        dataProvider.getCylindersByItem(
                            dataProvider.selectedCustomer!.customerId!,
                            selectedItem!.item!.id);
                      }
                    },
                  );
                },
              ),
            SizedBox(height: 15),
            if (widget.type == 'Leak' &&
                widget.leakTypeController.text != 'Leak Recive') ...[
              Consumer<DataProvider>(builder: (context, data, child) {
                return data.cylinderList.isEmpty
                    ? Text('No Cylinders')
                    : SizedBox(
                        height: 100,
                        width: 200,
                        child: ListView.builder(
                            itemCount: data.cylinderList.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) => CheckboxListTile(
                                  value: dataProvider.selectedCylinderList
                                      .contains(data.cylinderList[i]),
                                  onChanged: (bool? value) {
                                    //setState(() {
                                    if (dataProvider.selectedCylinderList
                                        .contains(data.cylinderList[i])) {
                                      widget.quantityController.text =
                                          (int.parse(widget.quantityController
                                                      .text) -
                                                  1)
                                              .toString();
                                      dataProvider.selectedCylinderList
                                          .remove(data.cylinderList[i]);
                                      dataProvider.selectedCylinderItemIds
                                          .remove(data.cylinderList[i].id);
                                    } else {
                                      dataProvider.selectedCylinderList
                                          .add(data.cylinderList[i]);
                                      dataProvider.selectedCylinderItemIds
                                          .add(data.cylinderList[i].id!);
                                      widget.quantityController.text =
                                          (int.parse(widget.quantityController
                                                      .text) +
                                                  1)
                                              .toString();
                                    }
                                    dataProvider.selectCylinder();
                                    //});
                                  },
                                  title: Text(
                                      data.cylinderList[i].cylinderNo ?? ''),
                                )),
                      );
              })
            ],
            if (widget.type == 'Default' || widget.type == 'Return')
              FutureBuilder<List<RoutecardItem>>(
                future: !_switchValue
                    ? getItemsByRoutecard(
                        routeCardId: routeCard.routeCardId,
                        priceLevelId:
                            dataProvider.selectedCustomer?.priceLevelId ?? 0,
                        type: widget.type == 'Return' ? 'return' : '')
                    : getNewItems(
                        routeCardId: routeCard.routeCardId,
                        priceLevelId:
                            dataProvider.selectedCustomer?.priceLevelId ?? 0,
                      ),
                builder:
                    (context, AsyncSnapshot<List<RoutecardItem>> snapshot) {
                  if (snapshot.hasData && snapshot.data![0].item != null) {
                    final routecardItem = snapshot.data![0];
                    widget.callBack(
                      selectedItem: routecardItem.item!,
                      maxQty: routecardItem.transferQty - routecardItem.sellQty,
                    );
                    selectedItem = routecardItem;
                  }
                  return DropdownButtonFormField<RoutecardItem>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText:
                          snapshot.connectionState == ConnectionState.waiting
                              ? 'Loading...'
                              : (snapshot.hasData ? 'Select item' : 'No items'),
                    ),
                    style: defaultTextFieldStyle,
                    value: snapshot.hasData ? snapshot.data![0] : null,
                    validator: (value) {
                      if (value == null) {
                        return 'Select an item!';
                      } else if (dataProvider.itemList
                          .where((element) => element.item.id == value.item!.id)
                          .isNotEmpty) {
                        return 'Already added!';
                      }
                      return null;
                    },
                    items: snapshot.hasData
                        ? snapshot.data!.toList().map((element) {
                            final item = element.item ?? dummyItem;
                            return DropdownMenuItem(
                              value: element,
                              child: Text(
                                item.itemName,
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          }).toList()
                        : [],
                    onChanged: (item) {
                      if (item != null) {
                        widget.callBack(
                          selectedItem: item.item!,
                          maxQty: item.transferQty - item.sellQty,
                        );
                        selectedItem = item;
                        quantityFocus.requestFocus();
                      }
                    },
                  );
                },
              ),
            const SizedBox(
              height: 10.0,
            ),
            if (widget.type == 'Default' ||
                widget.type == 'Loan' ||
                widget.type == 'Return')
              TextFormField(
                controller: widget.quantityController,
                focusNode: quantityFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Quantity',
                ),
                style: defaultTextFieldStyle,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Quantity cannot be empty!';
                  } else if (doub(text) <= 0) {
                    return 'Invalid quantity!';
                  } else if (doub(text) >
                          selectedItem!.transferQty - selectedItem!.sellQty &&
                      widget.type != 'Loan' &&
                      widget.type != 'Return') {
                    return 'Quantity exceeded (${num(selectedItem!.transferQty - selectedItem!.sellQty)})';
                  }
                  return null;
                },
              ),
            const SizedBox(
              height: 10.0,
            ),
            if (widget.type == 'Leak' &&
                widget.leakTypeController.text == 'Leak Recive')
              TextFormField(
                controller: widget.cylindserNumberController,
                //focusNode: quantityFocus,
                // keyboardType:
                //     const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Cylinder Number',
                ),
                style: defaultTextFieldStyle,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'This field cannot be empty!';
                  }
                  return null;
                },
              ),
            SizedBox(height: 15),
            if (widget.type == 'Leak' &&
                widget.leakTypeController.text == 'Leak Recive')
              TextFormField(
                controller: widget.referenceNumberController,
                //focusNode: quantityFocus,
                // keyboardType:
                //     const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Reference Number',
                ),
                style: defaultTextFieldStyle,
                validator: (text) {
                  // if (text == null || text.trim().isEmpty) {
                  //   return 'This field cannot be empty!';
                  // }
                  return null;
                },
              ),
            if (widget.type == 'Loan')
              Consumer<DataProvider>(builder: (context, _, __) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Select Issued/Recived',
                  ),
                  style: defaultTextFieldStyle,
                  value: 'Loan Recive',
                  items: ['Loan Recive', 'Loan Issue'].map((element) {
                    return DropdownMenuItem(
                      value: element,
                      child: Text(element),
                    );
                  }).toList(),
                  onChanged: dataProvider.itemList.isEmpty
                      ? (item) {
                          widget.loanItemController.text = item!;
                        }
                      : null,
                );
              })
          ],
        ),
      ),
    );
  }
}
