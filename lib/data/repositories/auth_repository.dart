import '../../core/network/api_helper.dart';
import '../models/login_response.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await _apiHelper.postFormData(ApiConstants.login, {
        'username': username,
        'password': password,
      }, requiresAuth: false);

      if (response.data != null) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(
          status: false,
          message: response.error ?? 'Login failed',
        );
      }
    } catch (e) {
      return LoginResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
