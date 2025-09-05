import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;

  const TextContainer({
    super.key,
    required this.text,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
