import 'package:flutter/material.dart';

class ToogleTextButton extends StatelessWidget {
  final String label;
  final void Function() onChanged;
  const ToogleTextButton(
      {super.key, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_circle_down, size: 28)
          ],
        ),
      ),
    );
  }
}
