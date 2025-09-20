import 'package:flutter/foundation.dart';
import 'package:gsr/commons/locator.dart';
import 'package:gsr/core/api_client.dart';
import 'package:gsr/core/api_endpoints.dart';
import 'package:gsr/models/customer/customer_model.dart';

class CustomerServiceV2 {
  final ApiClient _apiClient = locator<ApiClient>();

  Future<void> updateCustomer({
    required int customerId, 
    required double depositBalance
  }) async {
    await _apiClient.put(
      ApiEndpoints.customersUpdate,
      data: {
        "customerId": customerId,
        "depositBalance": depositBalance,
      },
    );
  }

  // Method 1: Using regular ApiResponse (current approach)
  Future<List<CustomerModel>> getCustomers(String pattern, {int? routeId}) async {
    try {
      final endpoint = routeId != null 
          ? '${ApiEndpoints.customersGetAll}?routeId=$routeId'
          : ApiEndpoints.customersGetAll;
          
      final response = await _apiClient.get(endpoint);

      if (response.data == null) {
        return [];
      }

      List<dynamic> list = response.data;
      if (list.isEmpty) {
        return [];
      }

      List<CustomerModel> allCustomers =
          list.map((element) => CustomerModel.fromJson(element)).toList();

      // If pattern is empty, return all customers
      if (pattern.trim().isEmpty) {
        return allCustomers;
      }

      // If pattern is too short, return all customers
      if (pattern.trim().length < 2) {
        return allCustomers;
      }

      // Filter customers based on pattern
      return allCustomers.where((customer) {
        final businessName = customer.businessName?.toLowerCase() ?? '';
        final ownerName = customer.ownerName?.toLowerCase() ?? '';
        final registrationId = customer.registrationId?.toLowerCase() ?? '';
        final patternLower = pattern.toLowerCase();

        return businessName.contains(patternLower) ||
               ownerName.contains(patternLower) ||
               registrationId.contains(patternLower);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error in getCustomers: $e');
      }
      return [];
    }
  }

  // Method 2: Using ApiResponseList<T> (type-safe approach)
  Future<List<CustomerModel>> getCustomersTyped(String pattern, {int? routeId}) async {
    try {
      final endpoint = routeId != null 
          ? '${ApiEndpoints.customersGetAll}?routeId=$routeId'
          : ApiEndpoints.customersGetAll;
          
      // Use the type-safe getList method
      final response = await _apiClient.getList<CustomerModel>(endpoint);

      if (!response.isSuccess || response.data == null) {
        return [];
      }

      List<CustomerModel> allCustomers = response.data!;

      // If pattern is empty, return all customers
      if (pattern.trim().isEmpty) {
        return allCustomers;
      }

      // If pattern is too short, return all customers
      if (pattern.trim().length < 2) {
        return allCustomers;
      }

      // Filter customers based on pattern
      return allCustomers.where((customer) {
        final businessName = customer.businessName?.toLowerCase() ?? '';
        final ownerName = customer.ownerName?.toLowerCase() ?? '';
        final registrationId = customer.registrationId?.toLowerCase() ?? '';
        final patternLower = pattern.toLowerCase();

        return businessName.contains(patternLower) ||
               ownerName.contains(patternLower) ||
               registrationId.contains(patternLower);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error in getCustomersTyped: $e');
      }
      return [];
    }
  }
}
