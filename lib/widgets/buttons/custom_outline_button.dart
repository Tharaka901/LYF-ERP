import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;

  const CustomOutlineButton({
    super.key,
    required this.text,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.0,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
