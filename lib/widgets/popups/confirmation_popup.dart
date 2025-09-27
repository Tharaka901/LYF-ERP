import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const ConfirmationPopup({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
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
            icon ?? Icons.help_outline,
            color: iconColor ?? Colors.blue,
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
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            backgroundColor: (cancelButtonColor ?? Colors.grey).withOpacity(0.1),
            foregroundColor: cancelButtonColor ?? Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            cancelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            backgroundColor: (confirmButtonColor ?? Colors.blue).withOpacity(0.1),
            foregroundColor: confirmButtonColor ?? Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Static method to show confirmation popup
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? textColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmationPopup(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
      ),
    ).then((result) => result ?? false);
  }

  // Quick confirmation popup for common scenarios
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    String? itemName,
  }) {
    return show(
      context,
      title: 'Delete Confirmation',
      message: itemName != null 
          ? 'Are you sure you want to delete "$itemName"? This action cannot be undone.'
          : 'Are you sure you want to delete this item? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
      iconColor: Colors.red,
      confirmButtonColor: Colors.red,
    );
  }

  static Future<bool> showSaveConfirmation(BuildContext context) {
    return show(
      context,
      title: 'Save Changes',
      message: 'Do you want to save the changes you made?',
      confirmText: 'Save',
      cancelText: 'Discard',
      icon: Icons.save,
      iconColor: Colors.blue,
      confirmButtonColor: Colors.blue,
    );
  }

  static Future<bool> showLogoutConfirmation(BuildContext context) {
    return show(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout,
      iconColor: Colors.orange,
      confirmButtonColor: Colors.orange,
    );
  }

  static Future<bool> showExitConfirmation(BuildContext context) {
    return show(
      context,
      title: 'Exit App',
      message: 'Are you sure you want to exit the application?',
      confirmText: 'Exit',
      cancelText: 'Cancel',
      icon: Icons.exit_to_app,
      iconColor: Colors.red,
      confirmButtonColor: Colors.red,
    );
  }
}
