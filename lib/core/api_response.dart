import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'],
      message: json['message'],
      error: json['error'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'error': error,
      'statusCode': statusCode,
    };
  }

  // Helper methods
  bool get isSuccess => success;
  bool get isError => !success;

  // For backward compatibility with existing Respo model
  factory ApiResponse.fromRespo(dynamic respo) {
    if (respo is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(respo);
    }
    return ApiResponse<T>(
      success: false,
      error: 'Invalid response format',
    );
  }
}

// Generic response types for common use cases
class ApiResponseList<T> extends ApiResponse<List<T>> {
  ApiResponseList({
    required super.success,
    super.data,
    super.message,
    super.error,
    super.statusCode,
  });

  factory ApiResponseList.fromJson(Map<String, dynamic> json) {
    return ApiResponseList<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? List<T>.from(json['data']) : null,
      message: json['message'],
      error: json['error'],
      statusCode: json['statusCode'],
    );
  }
}

class ApiResponseSingle<T> extends ApiResponse<T> {
  ApiResponseSingle({
    required super.success,
    super.data,
    super.message,
    super.error,
    super.statusCode,
  });

  factory ApiResponseSingle.fromJson(Map<String, dynamic> json,
      {T Function(Map<String, dynamic>)? fromJsonConverter}) {
    T? convertedData;
    if (json['data'] != null && fromJsonConverter != null) {
      try {
        convertedData = fromJsonConverter(json['data']);
      } catch (e) {
        // If conversion fails, data will remain null
        if (kDebugMode) {
          print('Error converting data: $e');
        }
      }
    }

    return ApiResponseSingle<T>(
      success: json['success'] ?? false,
      data: convertedData,
      message: json['message'],
      error: json['error'],
      statusCode: json['statusCode'],
    );
  }
}
