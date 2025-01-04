import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blue,
        ),
        // Add more theme configurations here
      );
}
