import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_endpoints.dart';
import '../core/utils/app_logger.dart';

class RegisterResult {
  final bool success;
  final String message;
  final String? code;
  final List<String> fieldErrors;
  final dynamic data;
  final dynamic details;

  RegisterResult({
    required this.success,
    required this.message,
    this.code,
    this.fieldErrors = const [],
    this.data,
    this.details,
  });

  factory RegisterResult.fromApiResponse(Map<String, dynamic> data, int statusCode) {
    final bool isSuccess = (statusCode >= 200 && statusCode < 300) && (data['success'] == true);

    if (isSuccess) {
      return RegisterResult(
        success: true,
        message: data['message'] ?? 'Operation successful',
        data: data['data'],
      );
    }

    String baseMessage = data['message']?.toString() ?? 'Invalid request details';
    final List<String> extractedFieldErrors = [];

    final details = data['details'];
    if (details != null && details is Map) {
      // Check for Zod/NestJS fieldErrors
      if (details.containsKey('fieldErrors') && details['fieldErrors'] is Map) {
        final Map fieldErrorsMap = details['fieldErrors'];
        fieldErrorsMap.forEach((key, val) {
          final label = _formatFieldLabel(key.toString());
          if (val is List) {
            for (var item in val) {
              extractedFieldErrors.add('$label: $item');
            }
          } else if (val != null) {
            extractedFieldErrors.add('$label: $val');
          }
        });
      } else {
        details.forEach((key, val) {
          if (key != 'formErrors') {
            final label = _formatFieldLabel(key.toString());
            if (val is List) {
              for (var item in val) {
                extractedFieldErrors.add('$label: $item');
              }
            } else if (val != null) {
              extractedFieldErrors.add('$label: $val');
            }
          }
        });
      }
    }

    // Clean up raw map text from base message if present
    if (baseMessage.contains('formErrors:') || baseMessage.contains('fieldErrors:')) {
      baseMessage = 'Please review and fix the highlighted form errors.';
    }

    return RegisterResult(
      success: false,
      message: baseMessage,
      code: data['code']?.toString() ?? 'VALIDATION_ERROR',
      fieldErrors: extractedFieldErrors,
      details: details,
    );
  }

  static String _formatFieldLabel(String key) {
    switch (key) {
      case 'fullName':
      case 'name':
        return 'Full Name';
      case 'email':
        return 'Email Address';
      case 'password':
        return 'Password';
      case 'confirmPassword':
        return 'Confirm Password';
      case 'emailOtp':
      case 'otp':
        return 'Email OTP';
      case 'phone':
        return 'Phone Number';
      default:
        if (key.isEmpty) return 'Field';
        return key[0].toUpperCase() + key.substring(1);
    }
  }
}

class AuthService {
  static const _validEmail = 'user@gmail.com';
  static const _validPassword = 'admin@123';

  Future<bool> login(String email, String password) async {
    AppLogger.logRequest(
      method: 'POST',
      url: '${ApiEndpoints.baseUrl}${ApiEndpoints.login}',
      body: {'email': email, 'password': '***'},
    );

    await Future.delayed(const Duration(milliseconds: 300));
    final success = email == _validEmail && password == _validPassword;

    AppLogger.logResponse(
      method: 'POST',
      url: '${ApiEndpoints.baseUrl}${ApiEndpoints.login}',
      statusCode: success ? 200 : 401,
      body: {
        'success': success,
        'message': success ? 'Login successful' : 'Invalid email or password',
      },
    );

    return success;
  }

  /// Request Email OTP for registration or verification
  Future<RegisterResult> sendOtp({
    required String email,
    String purpose = 'REGISTER',
  }) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.otpSend}';
    final payload = {
      'email': email,
      'purpose': purpose,
    };

    AppLogger.logRequest(
      method: 'POST',
      url: url,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      AppLogger.logResponse(
        method: 'POST',
        url: url,
        statusCode: response.statusCode,
        body: data,
      );

      return RegisterResult.fromApiResponse(data, response.statusCode);
    } catch (e, stackTrace) {
      AppLogger.logError(
        message: 'Failed to send OTP to $email',
        error: e,
        stackTrace: stackTrace,
      );

      return RegisterResult(
        success: false,
        message: 'Unable to connect to server. Please check your connection.',
        code: 'NETWORK_ERROR',
      );
    }
  }

  /// Register customer account via API
  Future<RegisterResult> registerCustomer({
    required String fullName,
    required String email,
    required String password,
    String? emailOtp,
    String? phone,
  }) async {
    final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.registerCustomer}';
    final Map<String, dynamic> body = {
      'fullName': fullName,
      'name': fullName,
      'email': email,
      'password': password,
    };

    if (emailOtp != null && emailOtp.trim().isNotEmpty) {
      body['emailOtp'] = emailOtp.trim();
    }
    if (phone != null && phone.trim().isNotEmpty) {
      body['phone'] = phone.trim();
    }

    AppLogger.logRequest(
      method: 'POST',
      url: url,
      headers: {'Content-Type': 'application/json'},
      body: {
        ...body,
        'password': '***',
      },
    );

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      AppLogger.logResponse(
        method: 'POST',
        url: url,
        statusCode: response.statusCode,
        body: data,
      );

      return RegisterResult.fromApiResponse(data, response.statusCode);
    } catch (e, stackTrace) {
      AppLogger.logError(
        message: 'Customer registration failed for $email',
        error: e,
        stackTrace: stackTrace,
      );

      return RegisterResult(
        success: false,
        message: 'Unable to connect to server. Please check network connection.',
        code: 'NETWORK_ERROR',
      );
    }
  }

  Future<void> logout() async {
    AppLogger.logRequest(
      method: 'POST',
      url: '${ApiEndpoints.baseUrl}${ApiEndpoints.logout}',
    );
  }
}
