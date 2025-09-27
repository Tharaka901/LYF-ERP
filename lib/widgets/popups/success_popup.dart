import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;

  const SuccessPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Row(
        children: [
          Icon(
            icon ?? Icons.check_circle_outline,
            color: iconColor ?? Colors.green,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor ?? Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          color: textColor ?? Colors.black54,
          fontSize: 16,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green.shade50,
            foregroundColor: Colors.green.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            buttonText ?? 'OK',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Static method to show success popup
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SuccessPopup(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
      ),
    );
  }

  // Quick success popup for common scenarios
  static Future<void> showDataSaved(BuildContext context) {
    return show(
      context,
      title: 'Success',
      message: 'Data has been saved successfully.',
      icon: Icons.save,
      iconColor: Colors.green,
    );
  }

  static Future<void> showDataUpdated(BuildContext context) {
    return show(
      context,
      title: 'Updated',
      message: 'Data has been updated successfully.',
      icon: Icons.update,
      iconColor: Colors.green,
    );
  }

  static Future<void> showDataDeleted(BuildContext context) {
    return show(
      context,
      title: 'Deleted',
      message: 'Data has been deleted successfully.',
      icon: Icons.delete_outline,
      iconColor: Colors.green,
    );
  }

  static Future<void> showOperationCompleted(BuildContext context) {
    return show(
      context,
      title: 'Completed',
      message: 'Operation completed successfully.',
      icon: Icons.task_alt,
      iconColor: Colors.green,
    );
  }
}
