import 'package:gsr/core/api_client.dart';
import 'package:gsr/core/api_response.dart';
import 'package:gsr/models/employee/employee_model.dart';

class EmployeeService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<EmployeeModel>> login(
      String contactNumber, String password) async {
    return _apiClient.postSingle<EmployeeModel>('employees/login', data: {
      'contactNumber': contactNumber,
      'password': password,
    });
  }
}
