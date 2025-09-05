import 'package:flutter/material.dart';
import '../commons/common_consts.dart';

class AppStyles {
  static InputDecoration textFieldDecoration({
    String? labelText,
    Color? fillColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      fillColor: fillColor ?? Colors.grey[200],
      filled: true,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: defaultBorderRadius,
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: defaultBorderRadius,
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: defaultBorderRadius,
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }
}
