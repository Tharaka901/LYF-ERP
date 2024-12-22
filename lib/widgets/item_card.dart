import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final Widget? trailing;
  final Widget? leading;
  final List<SAction>? actions;
  const ItemCard({
    Key? key,
    required this.item,
    this.trailing,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: defaultElevation,
      shape: defaultShape,
      child: Slidable(
        enabled: actions != null && actions!.isNotEmpty,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: actions ?? [],
        ),
        child: ListTile(
          shape: defaultShape,
          title: Text(
            item.itemName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: leading,
          subtitle: const Text(
            'numUnit(item.itemQuantity)',
            style: TextStyle(color: Colors.black),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}

class SAction extends StatelessWidget {
  final String? label;
  final IconData icon;
  final void Function(BuildContext)? onPressed;
  final Color? color;
  const SAction({
    Key? key,
    this.label,
    required this.icon,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: color ?? Colors.red,
      label: label,
      icon: icon,
    );
  }
}
