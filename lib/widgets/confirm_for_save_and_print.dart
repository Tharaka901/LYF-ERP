import 'package:flutter/material.dart';

Future confirmForSaveAndPrint(
  BuildContext context, {
  required Function() onSave,
  required Function() onSaveAndPrint,
}) {
  const style = TextStyle(fontSize: 20.0);
  return showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the radius as needed
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          TextButton(
            onPressed: onSave,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/save.png',
                  height: 55,
                  width: 55,
                ),
                Text(
                  'Save',
                  style: style,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: onSaveAndPrint,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/printer.png',
                  height: 55,
                  width: 55,
                ),
                Text(
                  'Save And Print',
                  style: style,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
