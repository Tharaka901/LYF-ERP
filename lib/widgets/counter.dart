import 'package:flutter/material.dart';
import 'package:gsr/models/item.dart';
import 'package:provider/provider.dart';

import '../models/added_item.dart';
import '../models/item/item_model.dart';
import '../models/route_card_item/route_card_item_model.dart';
import '../providers/data_provider.dart';

class CounterWidget extends StatefulWidget {
  final RouteCardItemModel routecardItem;

  const CounterWidget({super.key, required this.routecardItem});
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;
  DataProvider? dataProvider;
  TextEditingController _textEditingController = TextEditingController();

  void increaseCount(DataProvider dataProvider) {
    if (widget.routecardItem.transferQty - widget.routecardItem.sellQty >
        count) {
      if (dataProvider.itemList
          .map((e) => e.item.id)
          .contains(widget.routecardItem.item?.id)) {
        dataProvider.itemList.forEach((item) {
          if (item.item.id == widget.routecardItem.item?.id) {
            item.quantity += 1;
          }
        });
      } else {
        final item = widget.routecardItem.item;
        dataProvider.addItem(
          AddedItem(
            item: ItemModel(
                id: item!.id!,
                itemRegNo: item.itemRegNo ?? '',
                itemName: item.itemName ?? '',
                costPrice: item.costPrice ?? 0,
                salePrice: item.salePrice ?? 0,
                openingQty: item.openingQty ?? 0,
                vendorId: item.vendorId ?? 0,
                priceLevelId: item.priceLevelId ?? 0,
                itemTypeId: item.itemTypeId ?? 0,
                stockId: item.stockId,
                costAccId: item.costAccId,
                incomeAccId: item.incomeAccId,
                isNew: item.isNew,
                status: item.status,
                nonVatAmount: item.hasSpecialPrice != null
                    ? item.hasSpecialPrice?.nonVatAmount
                    : item.nonVatAmount),
            quantity: 1,
            maxQuantity: 1,
          ),
        );
      }
      setState(() {
        count++;
        _textEditingController.text = count.toString();
      });
    }
  }

  void decreaseCount(DataProvider dataProvider) {
    if (count > 0) {
      List<AddedItem> copyList = List.from(dataProvider.itemList);
      copyList.forEach((item) {
        if (item.item.id == widget.routecardItem.item?.id) {
          if (item.quantity != 1) {
            item.quantity -= 1;
          } else {
            dataProvider.itemList.removeWhere(
                (item) => item.item.id == widget.routecardItem.item?.id);
          }
        }
      });
      setState(() {
        count--;
        _textEditingController.text = count.toString();
      });
    }
  }

  void onTextFieldChange(double value, DataProvider dataProvider) {
    if (widget.routecardItem.transferQty - widget.routecardItem.sellQty >=
        value) {
      if (dataProvider.itemList
          .map((e) => e.item.id)
          .contains(widget.routecardItem.item?.id)) {
        dataProvider.itemList.forEach((item) {
          if (item.item.id == widget.routecardItem.item?.id) {
            item.quantity = value;
          }
        });
      } else {
        final item = widget.routecardItem.item;
        dataProvider.addItem(
          AddedItem(
            item: ItemModel(
                id: item!.id!,
                itemRegNo: item.itemRegNo ?? '',
                itemName: item.itemName ?? '',
                costPrice: item.costPrice ?? 0,
                salePrice: item.salePrice ?? 0,
                openingQty: item.openingQty ?? 0,
                vendorId: item.vendorId,
                priceLevelId: item.priceLevelId,
                itemTypeId: item.itemTypeId,
                stockId: item.stockId,
                costAccId: item.costAccId,
                incomeAccId: item.incomeAccId,
                isNew: item.isNew,
                status: item.status,
                nonVatAmount: item.hasSpecialPrice != null
                    ? item.hasSpecialPrice?.nonVatAmount
                    : item.nonVatAmount),
            quantity: value,
            maxQuantity: 1,
          ),
        );
      }
      setState(() {
        count = value.toInt();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
  }

  @override
  void dispose() {
    //dataProvider?.itemList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Row(
      children: [
        // Decrease Button
        IconButton(
          icon: Icon(Icons.remove, size: 30),
          onPressed: () {
            decreaseCount(dataProvider);
          },
          color: Colors.red, // Customize the button color
        ),

        // Middle Value
        Container(
          width: 60,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: _textEditingController,
            onChanged: (newValue) {
              onTextFieldChange(double.parse(newValue), dataProvider);
            },
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
          ),
        ),

        // Increase Button
        IconButton(
          icon: Icon(Icons.add, size: 30),
          onPressed: () {
            increaseCount(dataProvider);
          },
          color: Colors.green,
        ),
      ],
    );
  }
}
