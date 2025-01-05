import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/commons/common_methods.dart';

class ChequeCard extends StatelessWidget {
  final String chequeNumber;
  final double chequeAmount;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? leading;
  final bool? enabled;
  final bool? selected;
  const ChequeCard({
    Key? key,
    required this.chequeNumber,
    required this.chequeAmount,
    this.onTap,
    this.trailing,
    this.leading,
    this.enabled,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: defaultElevation,
      shape: defaultShape,
      child: ListTile(
        enabled: enabled ?? true,
        selectedTileColor: Colors.green,
        selectedColor: Colors.white,
        selected: selected ?? false,
        shape: defaultShape,
        title: Text(chequeNumber),
        subtitle: Text(
          formatPrice(chequeAmount),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
        leading: leading ??
            (selected != null
                ? (selected!
                    ? const Icon(Icons.check_box_rounded)
                    : const Icon(Icons.check_box_outline_blank_rounded))
                : null),
        trailing: trailing,
      ),
    );
  }
}
