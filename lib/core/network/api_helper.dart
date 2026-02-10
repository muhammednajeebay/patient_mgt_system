import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_logger.dart';
import '../services/storage_service.dart';
import '../constants/api_constants.dart';

class ApiResponse {
  final dynamic data;
  final int statusCode;
  final String? error;

  ApiResponse({this.data, required this.statusCode, this.error});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiHelper {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders(bool requiresAuth) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<ApiResponse> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth);

      AppLogger.info('GET Request: $url');
      final response = await http.get(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      AppLogger.error('GET Request Error: $e');
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth);

      AppLogger.info('POST Request: $url');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      AppLogger.error('POST Request Error: $e');
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> postFormData(
    String endpoint,
    Map<String, String> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final request = http.MultipartRequest('POST', url);

      final headers = await _getHeaders(requiresAuth);
      request.headers.addAll(headers);
      request.fields.addAll(body);

      AppLogger.info('POST FormData Request: $url');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      AppLogger.error('POST FormData Error: $e');
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    AppLogger.info('Response Code: ${response.statusCode}');

    try {
      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
          data: data,
          statusCode: response.statusCode,
          error: data['message'] ?? 'Something went wrong',
        );
      }
    } catch (e) {
      return ApiResponse(
        statusCode: response.statusCode,
        error: 'Failed to parse response: $e',
      );
    }
  }
}
