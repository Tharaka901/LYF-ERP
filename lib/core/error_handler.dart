import 'package:flutter/material.dart';
import 'package:gsr/core/api_response.dart';
import 'package:gsr/widgets/popups/error_popup.dart';
import 'package:gsr/widgets/popups/loading_popup.dart';

class ErrorHandler {
  // Handle API response errors
  static Future<void> handleApiError(
    BuildContext context,
    ApiResponse response, {
    String? customMessage,
  }) async {
    // Hide any loading popup first
    LoadingPopup.hide(context);

    String title = 'Error';
    String message = customMessage ?? 'Something went wrong. Please try again.';
    IconData icon = Icons.error_outline;
    Color iconColor = Colors.red;

    // Handle specific error types based on status code or error message
    if (response.statusCode != null) {
      switch (response.statusCode) {
        case 400:
          title = 'Bad Request';
          message = response.error ?? 'Invalid request. Please check your input.';
          icon = Icons.warning_amber;
          iconColor = Colors.amber;
          break;
        case 401:
          title = 'Unauthorized';
          message = 'You are not authorized to perform this action.';
          icon = Icons.lock;
          iconColor = Colors.red;
          break;
        case 403:
          title = 'Forbidden';
          message = 'You do not have permission to access this resource.';
          icon = Icons.block;
          iconColor = Colors.red;
          break;
        case 404:
          title = 'Not Found';
          message = 'The requested resource was not found.';
          icon = Icons.search_off;
          iconColor = Colors.grey;
          break;
        case 408:
          title = 'Request Timeout';
          message = 'The request took too long to complete. Please try again.';
          icon = Icons.timer_off;
          iconColor = Colors.orange;
          break;
        case 500:
          title = 'Server Error';
          message = 'Something went wrong on our end. Please try again later.';
          icon = Icons.error_outline;
          iconColor = Colors.red;
          break;
        case 502:
        case 503:
        case 504:
          title = 'Service Unavailable';
          message = 'The service is temporarily unavailable. Please try again later.';
          icon = Icons.cloud_off;
          iconColor = Colors.orange;
          break;
        default:
          if (response.error != null) {
            message = response.error!;
          }
          break;
      }
    } else if (response.error != null) {
      // Handle network errors or other errors
      if (response.error!.toLowerCase().contains('network') ||
          response.error!.toLowerCase().contains('connection') ||
          response.error!.toLowerCase().contains('timeout')) {
        title = 'Network Error';
        message = 'Please check your internet connection and try again.';
        icon = Icons.wifi_off;
        iconColor = Colors.orange;
      } else if (response.error!.toLowerCase().contains('server')) {
        title = 'Server Error';
        message = 'Something went wrong on our end. Please try again later.';
        icon = Icons.error_outline;
        iconColor = Colors.red;
      } else {
        message = response.error!;
      }
    }

    // Show error popup
    await ErrorPopup.show(
      context,
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
    );
  }

  // Handle generic errors
  static Future<void> handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
  }) async {
    // Hide any loading popup first
    LoadingPopup.hide(context);

    String title = 'Error';
    String message = customMessage ?? 'Something went wrong. Please try again.';
    IconData icon = Icons.error_outline;
    Color iconColor = Colors.red;

    // Handle specific error types
    if (error is String) {
      message = error;
    } else if (error.toString().toLowerCase().contains('network') ||
               error.toString().toLowerCase().contains('connection')) {
      title = 'Network Error';
      message = 'Please check your internet connection and try again.';
      icon = Icons.wifi_off;
      iconColor = Colors.orange;
    } else if (error.toString().toLowerCase().contains('timeout')) {
      title = 'Request Timeout';
      message = 'The request took too long to complete. Please try again.';
      icon = Icons.timer_off;
      iconColor = Colors.orange;
    }

    // Show error popup
    await ErrorPopup.show(
      context,
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
    );
  }

  // Handle validation errors
  static Future<void> handleValidationError(
    BuildContext context,
    String message,
  ) async {
    await ErrorPopup.showValidationError(context, message: message);
  }

  // Handle network errors
  static Future<void> handleNetworkError(BuildContext context) async {
    await ErrorPopup.showNetworkError(context);
  }

  // Handle server errors
  static Future<void> handleServerError(BuildContext context) async {
    await ErrorPopup.showServerError(context);
  }

  // Handle unauthorized errors
  static Future<void> handleUnauthorizedError(BuildContext context) async {
    await ErrorPopup.showUnauthorizedError(context);
  }

  // Handle not found errors
  static Future<void> handleNotFoundError(BuildContext context) async {
    await ErrorPopup.showNotFoundError(context);
  }

  // Handle timeout errors
  static Future<void> handleTimeoutError(BuildContext context) async {
    await ErrorPopup.showTimeoutError(context);
  }
}
