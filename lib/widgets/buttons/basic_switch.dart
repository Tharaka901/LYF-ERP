import 'package:flutter/material.dart';
import 'package:gsr/providers/items_provider.dart';
import 'package:provider/provider.dart';

class BasicSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool) onChanged;
  const BasicSwitch({super.key, required this.title, required this.onChanged, required this.value});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, ip, _) {
      return Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      );
    });
  }
}
