import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'user@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'admin@123');
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      context.go(AppRoutes.home);
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              children: [
                SizedBox(height: 48.h),
                Hero(
                  tag: 'untense_logo',
                  child: Image.asset(
                    AppConstants.logoPath,
                    height: 88.h,
                    fit: BoxFit.contain,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.94, 0.94),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                    ),
                SizedBox(height: 36.h),
                Text(
                  'Welcome to UnTense',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge,
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 450.ms)
                    .slideY(begin: 0.12, end: 0, delay: 100.ms),
                SizedBox(height: 12.h),
                Text(
                  'Sign in to connect with trusted experts and start feeling lighter.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                )
                    .animate()
                    .fadeIn(delay: 180.ms, duration: 450.ms),
                SizedBox(height: 32.h),
                // Form section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 12.h),
                      Text(
                        _errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 24.h),
                    PrimaryButton(
                      label: _isLoading ? 'Signing in...' : 'Sign In',
                      onPressed: _isLoading ? null : _handleLogin,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  'By continuing, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 28.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

