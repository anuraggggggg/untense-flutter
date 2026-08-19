import 'package:untense_app/providers/auth_provider.dart';

// Global instance of AuthProvider used for GoRouter refreshListenable and Provider.
final authProvider = AuthProvider()..initialize();
