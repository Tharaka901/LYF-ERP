import 'package:flutter/material.dart';
import 'package:gsr/models/route_card_item/route_card_item_model.dart';

import '../counter.dart';

class AddItemCard extends StatelessWidget {
  final RouteCardItemModel routecardItem;
  const AddItemCard(this.routecardItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              routecardItem.item?.itemName ?? '',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            CounterWidget(
              routecardItem: routecardItem,
            )
          ],
        ),
      ),
    );
  }
}
