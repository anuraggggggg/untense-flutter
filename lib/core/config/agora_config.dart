/// Agora configuration constants and token helper for UnTense.
abstract class AgoraConfig {
  /// Agora App ID
  static const String appId = '0dbc490e8c294e2ca7b417e3d06c919c';

  /// Agora Primary Certificate
  static const String appCertificate = 'c30b152091694ffb86363efb4b9f7b69';

  /// Set to true if testing with App ID only mode (without token validation),
  /// or false when using dynamic tokens from backend / token server.
  static const bool useTempToken = false;

  /// Default temporary token for testing (if enabled on Agora Console)
  static const String tempToken = '';

  /// Retrieve the RTC token for a given channel and UID.
  /// Replace this with your backend server URL in production.
  static Future<String> getRtcToken({
    required String channelName,
    required int uid,
  }) async {
    if (useTempToken) {
      return tempToken;
    }
    // For development, returning tempToken or empty string allows joining if token isn't strictly enforced in console.
    // If Primary Certificate is enforced, your backend should sign and return the token.
    return tempToken;
  }
}
