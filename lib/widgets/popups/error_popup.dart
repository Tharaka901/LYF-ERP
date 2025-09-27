import 'package:flutter/material.dart';

class ErrorPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;

  const ErrorPopup({
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
            icon ?? Icons.error_outline,
            color: iconColor ?? Colors.red,
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
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
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

  // Static method to show error popup
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
      builder: (context) => ErrorPopup(
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

  // Quick error popup for common scenarios
  static Future<void> showNetworkError(BuildContext context) {
    return show(
      context,
      title: 'Network Error',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      iconColor: Colors.orange,
    );
  }

  static Future<void> showServerError(BuildContext context) {
    return show(
      context,
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      icon: Icons.error_outline,
      iconColor: Colors.red,
    );
  }

  static Future<void> showValidationError(
    BuildContext context, {
    required String message,
  }) {
    return show(
      context,
      title: 'Validation Error',
      message: message,
      icon: Icons.warning_amber,
      iconColor: Colors.amber,
    );
  }

  static Future<void> showUnauthorizedError(BuildContext context) {
    return show(
      context,
      title: 'Unauthorized',
      message: 'You are not authorized to perform this action.',
      icon: Icons.lock,
      iconColor: Colors.red,
    );
  }

  static Future<void> showNotFoundError(BuildContext context) {
    return show(
      context,
      title: 'Not Found',
      message: 'The requested resource was not found.',
      icon: Icons.search_off,
      iconColor: Colors.grey,
    );
  }

  static Future<void> showTimeoutError(BuildContext context) {
    return show(
      context,
      title: 'Request Timeout',
      message: 'The request took too long to complete. Please try again.',
      icon: Icons.timer_off,
      iconColor: Colors.orange,
    );
  }
}
