import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';

class OptionCard extends StatelessWidget {
  final dynamic title;
  final double? titleFontSize;
  final dynamic subtitle;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? leading;
  final bool? enabled;
  final bool? selected;
  final double? elevation;
  final double? cornerRadius;
  final double? verticlePadding;
  final double? height;
  final Color? color;
  const OptionCard({
    Key? key,
    required this.title,
    this.titleFontSize,
    this.onTap,
    this.subtitle,
    this.trailing,
    this.leading,
    this.enabled,
    this.selected,
    this.elevation,
    this.cornerRadius,
    this.verticlePadding,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.grey.shade100,
      elevation: elevation ?? defaultElevation,
      shape: cornerRadius == null
          ? defaultShape
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 10.0)),
      child: Padding(
        padding: verticlePadding == null
            ? const EdgeInsets.all(0.0)
            : EdgeInsets.symmetric(
                horizontal: 0,
                vertical: verticlePadding ?? 5.0,
              ),
        child: ListTile(
          enabled: enabled ?? true,
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          selected: selected ?? false,
          shape: defaultShape,
          title: title is String
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: height ?? 0.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: height ?? 0.0),
                  child: title,
                ),
          subtitle: subtitle != null
              ? (subtitle is String ? Text(subtitle!) : subtitle)
              : null,
          onTap: onTap,
          leading: leading ??
              (selected != null
                  ? (selected!
                      ? const Icon(Icons.check_box_rounded)
                      : const Icon(Icons.check_box_outline_blank_rounded))
                  : null),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: trailing,
          ),
        ),
      ),
    );
  }
}
