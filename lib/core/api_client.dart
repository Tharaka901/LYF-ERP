import 'package:dio/dio.dart';
import 'package:gsr/commons/common_consts.dart';
import 'package:gsr/core/api_response.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors if needed
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<ApiResponse> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? data}) async {
    print('data');
    print(data);
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      print('response1');
      print(response.data);
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<ApiResponse> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<ApiResponse> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Type-safe methods for common use cases
  Future<ApiResponseList<T>> getList<T>(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    final response = await get(endpoint, queryParameters: queryParameters);
    return ApiResponseList<T>.fromJson(response.toJson());
  }

  Future<ApiResponseSingle<T>> getSingle<T>(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    final response = await get(endpoint, queryParameters: queryParameters);
    return ApiResponseSingle<T>.fromJson(response.toJson());
  }

  Future<ApiResponseSingle<T>> postSingle<T>(String endpoint, {Map<String, dynamic>? data, T Function(Map<String, dynamic>)? fromJsonConverter}) async {
    final response = await post(endpoint, data: data);
    return ApiResponseSingle<T>.fromJson(response.toJson(), fromJsonConverter: fromJsonConverter);
  }
}
