import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Professional terminal logging utility for API requests, responses, tokens, and errors.
abstract final class AppLogger {
  static const String _reset = '\x1B[0m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _magenta = '\x1B[35m';
  static const String _bold = '\x1B[1m';

  /// Log outgoing API Request
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    if (!kDebugMode) return;
    final timestamp = DateTime.now().toIso8601String().split('T').last;

    debugPrint('');
    debugPrint('$_cyan$_bold=================== [API REQUEST] ===================$_reset');
    debugPrint('$_cyan[$timestamp] $method => $url$_reset');
    if (headers != null && headers.isNotEmpty) {
      debugPrint('$_cyan' 'Headers: ${_prettyJson(headers)}$_reset');
    }
    if (body != null) {
      debugPrint('$_cyan' 'Payload: ${_formatBody(body)}$_reset');
    }
    debugPrint('$_cyan====================================================$_reset');
  }

  /// Log incoming API Response
  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    dynamic body,
    String? token,
  }) {
    if (!kDebugMode) return;
    final timestamp = DateTime.now().toIso8601String().split('T').last;
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final color = isSuccess ? _green : _red;

    debugPrint('');
    debugPrint('$color$_bold=================== [API RESPONSE] ===================$_reset');
    debugPrint('$color[$timestamp] Status: $statusCode | $method => $url$_reset');
    if (body != null) {
      debugPrint('$color' 'Response Body:\n${_formatBody(body)}$_reset');
    }
    debugPrint('$color====================================================$_reset');

    // Extract token if embedded in response body or explicitly provided
    final extractedToken = token ?? _extractTokenFromBody(body);
    if (extractedToken != null && extractedToken.isNotEmpty) {
      logToken(extractedToken);
    }
  }

  /// Explicitly print Bearer Token in terminal
  static void logToken(String token) {
    if (!kDebugMode) return;
    final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;
    debugPrint('');
    debugPrint('$_magenta$_bold🔑 ================= [BEARER TOKEN] ================= 🔑$_reset');
    debugPrint('$_magenta$_bold Authorization: Bearer $cleanToken$_reset');
    debugPrint('$_magenta$_bold Token String: $cleanToken$_reset');
    debugPrint('$_magenta$_bold🔑 ==================================================== 🔑$_reset');
  }

  /// Log API or Application Error
  static void logError({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    final timestamp = DateTime.now().toIso8601String().split('T').last;

    debugPrint('');
    debugPrint('$_red$_bold=================== [ERROR DETECTED] ===================$_reset');
    debugPrint('$_red[$timestamp] ❌ $message$_reset');
    if (error != null) {
      debugPrint('$_red' 'Details: $error$_reset');
    }
    if (stackTrace != null) {
      debugPrint('$_yellow' 'StackTrace:\n$stackTrace$_reset');
    }
    debugPrint('$_red======================================================$_reset');
  }

  /// Helper to extract token fields from dynamic response body
  static String? _extractTokenFromBody(dynamic body) {
    if (body == null) return null;
    try {
      Map<String, dynamic>? map;
      if (body is Map<String, dynamic>) {
        map = body;
      } else if (body is String) {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) map = decoded;
      }
      if (map != null) {
        if (map['token'] != null) return map['token'].toString();
        if (map['accessToken'] != null) return map['accessToken'].toString();
        if (map['jwt'] != null) return map['jwt'].toString();
        if (map['authToken'] != null) return map['authToken'].toString();
        if (map['data'] is Map<String, dynamic>) {
          final dataMap = map['data'] as Map<String, dynamic>;
          if (dataMap['token'] != null) return dataMap['token'].toString();
          if (dataMap['accessToken'] != null) return dataMap['accessToken'].toString();
          if (dataMap['jwt'] != null) return dataMap['jwt'].toString();
          if (dataMap['authToken'] != null) return dataMap['authToken'].toString();
        }
      }
    } catch (_) {}
    return null;
  }

  /// Format dynamic body into clean JSON string
  static String _formatBody(dynamic body) {
    if (body == null) return 'null';
    if (body is String) {
      try {
        final parsed = jsonDecode(body);
        return _prettyJson(parsed);
      } catch (_) {
        return body;
      }
    }
    if (body is Map || body is List) {
      return _prettyJson(body);
    }
    return body.toString();
  }

  static String _prettyJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }
}
