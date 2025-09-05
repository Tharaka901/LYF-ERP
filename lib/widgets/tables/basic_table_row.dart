import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  final String value;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const CustomTableCell({
    super.key,
    required this.value,
    this.textAlign = TextAlign.center,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: textAlign,
          style: textStyle,
        ),
      ),
    );
  }
}
