import 'package:flutter/material.dart';

class LoadingPopup extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? indicatorColor;
  final double? indicatorSize;

  const LoadingPopup({
    super.key,
    this.message,
    this.backgroundColor,
    this.textColor,
    this.indicatorColor,
    this.indicatorSize,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: indicatorSize ?? 50,
            height: indicatorSize ?? 50,
            child: CircularProgressIndicator(
              color: indicatorColor ?? Colors.blue,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: textColor ?? Colors.black54,
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // Static method to show loading popup
  static Future<void> show(
    BuildContext context, {
    String? message,
    Color? backgroundColor,
    Color? textColor,
    Color? indicatorColor,
    double? indicatorSize,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingPopup(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        indicatorColor: indicatorColor,
        indicatorSize: indicatorSize,
      ),
    );
  }

  // Quick loading popup for common scenarios
  static Future<void> showSaving(BuildContext context) {
    return show(
      context,
      message: 'Saving...',
      indicatorColor: Colors.green,
    );
  }

  static Future<void> showLoading(BuildContext context) {
    return show(
      context,
      message: 'Loading...',
      indicatorColor: Colors.blue,
    );
  }

  static Future<void> showProcessing(BuildContext context) {
    return show(
      context,
      message: 'Processing...',
      indicatorColor: Colors.orange,
    );
  }

  static Future<void> showUploading(BuildContext context) {
    return show(
      context,
      message: 'Uploading...',
      indicatorColor: Colors.purple,
    );
  }

  static Future<void> showDownloading(BuildContext context) {
    return show(
      context,
      message: 'Downloading...',
      indicatorColor: Colors.teal,
    );
  }

  // Method to hide loading popup
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
