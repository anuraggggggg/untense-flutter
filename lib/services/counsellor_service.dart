import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_endpoints.dart';
import '../core/utils/app_logger.dart';
import '../models/counsellor.dart';
import 'auth_service.dart';

class CounsellorService {
  /// Fetch live list of counsellors from backend API
  Future<List<Counsellor>> getCounsellors({
    String? categoryId,
    String? specialisationId,
    String? search,
    String? sortBy,
    int? minRating,
    int? minHourlyRate,
    int? maxHourlyRate,
    int page = 1,
    int limit = 30,
  }) async {
    final Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'All') {
      queryParams['categoryId'] = categoryId;
    }
    if (specialisationId != null && specialisationId.isNotEmpty) {
      queryParams['specialisationId'] = specialisationId;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (sortBy != null && sortBy.isNotEmpty && sortBy != 'default') {
      queryParams['sortBy'] = sortBy;
    }
    if (minRating != null) {
      queryParams['minRating'] = minRating.toString();
    }
    if (minHourlyRate != null) {
      queryParams['minHourlyRate'] = minHourlyRate.toString();
    }
    if (maxHourlyRate != null) {
      queryParams['maxHourlyRate'] = maxHourlyRate.toString();
    }
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();

    final baseUri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.counsellors}');
    final uri = baseUri.replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final token = await AuthService.getAuthToken();
    final headers = <String, String>{
      'accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    AppLogger.logRequest(
      method: 'GET',
      url: uri.toString(),
      headers: headers,
    );

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      AppLogger.logResponse(
        method: 'GET',
        url: uri.toString(),
        statusCode: response.statusCode,
        body: data,
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        final items = data['data']?['items'] as List?;
        if (items != null) {
          return items
              .map((item) => Counsellor.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e, stackTrace) {
      AppLogger.logError(
        message: 'Failed to fetch counsellors list from API',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get single counsellor details by ID
  Future<Counsellor?> getCounsellorById(String id) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.counsellors}/$id');
    final token = await AuthService.getAuthToken();
    final headers = <String, String>{
      'accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    AppLogger.logRequest(
      method: 'GET',
      url: uri.toString(),
      headers: headers,
    );

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      AppLogger.logResponse(
        method: 'GET',
        url: uri.toString(),
        statusCode: response.statusCode,
        body: data,
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['success'] == true) {
        final raw = data['data'];
        if (raw is Map<String, dynamic>) {
          return Counsellor.fromJson(raw);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.logError(
        message: 'Failed to fetch counsellor by ID: $id',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }
}
