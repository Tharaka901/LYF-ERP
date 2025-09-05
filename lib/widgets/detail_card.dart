import 'package:flutter/material.dart';
import 'package:gsr/commons/common_consts.dart';

class DetailCard extends StatelessWidget {
  final String detailKey;
  final String detailvalue;
  final Widget? leading;
  final Widget? trailing;
  const DetailCard({
    Key? key,
    required this.detailKey,
    required this.detailvalue,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: defaultShape,
      title: Text(
        detailKey,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
      subtitle: Text(
        detailvalue,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
      leading: leading,
      trailing: trailing,
    );
  }
}
