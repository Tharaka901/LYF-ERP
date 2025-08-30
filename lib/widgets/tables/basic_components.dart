import 'package:flutter/material.dart';

TableCell cell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
        ),
      ),
    );
TableCell titleCell(String value, {TextAlign? align}) => TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: align ?? TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );