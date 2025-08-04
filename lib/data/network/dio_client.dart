import 'package:dio/dio.dart';
import './/config/app_config.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBY2NvdW50SWQiOiI0NDUiLCJDb21wYW55SWQiOiIyNzYiLCJFbWFpbCI6InBhdmVsMTQ2NDBAaXRsdGVhbS50ZXN0IiwiUGhvbmUiOiIrNyA4MjEgNzM4LTAxLTYwIiwiQ29tcGFueUNvZGUiOiIiLCJDb21wYW55TmFtZSI6IlRyYW5zZm9ybWVycyBjb3Jwb3JhdGlvbiIsIkNvbXBhbnlMb2NhbGUiOiJydSIsIlJvbGUiOiJPd25lciIsIklzQm90IjoiRmFsc2UiLCJuYmYiOjE3NTQwNDQ0ODksImV4cCI6MTg1NDA0NDc4OSwiaXNzIjoiVW51a1NlcnZlciIsImF1ZCI6IlVudWtDbGllbnQifQ.RPsgIlDAhWHjIdWvnNRPk2wTlMFP1xKh-l6fRqGQ5Ds',
    };
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
