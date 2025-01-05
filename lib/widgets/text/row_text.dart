import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final MainAxisAlignment? mainAxisAlignment;
  const RowText({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
        ),
        const SizedBox(width: 5.0),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontSize: 16.0,
              ),
        ),
      ],
    );
  }
}
