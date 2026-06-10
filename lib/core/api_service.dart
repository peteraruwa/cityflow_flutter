import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _formatDioError(error);
    } catch (error) {
      throw Exception('GET request failed: $error');
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _formatDioError(error);
    } catch (error) {
      throw Exception('POST request failed: $error');
    }
  }

  Exception _formatDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    final message = error.message ?? 'Network request failed';

    if (statusCode != null) {
      return Exception('Request failed with status $statusCode: $responseData');
    }

    return Exception(message);
  }
}
