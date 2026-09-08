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
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
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
        _errorMessage = 'Invalid email or password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                // Logo Header
                Hero(
                  tag: 'untense_logo',
                  child: Image.asset(
                    AppConstants.logoPath,
                    height: 72.h,
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn(duration: 400.ms),

                SizedBox(height: 20.h),

                // Top Segmented Mode Switcher (Log In vs Sign Up)
                _AuthSegmentedToggle(
                  isLogin: true,
                  onSelectLogin: () {},
                  onSelectRegister: () => context.go(AppRoutes.register),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                SizedBox(height: 24.h),

                // Mode Badge Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login_rounded, size: 16.sp, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Text(
                        'SIGN IN TO YOUR ACCOUNT',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms),

                SizedBox(height: 12.h),

                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge,
                ).animate().fadeIn(delay: 200.ms),

                SizedBox(height: 8.h),

                Text(
                  'Enter your credentials below to sign in and continue your journey.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                ).animate().fadeIn(delay: 250.ms),

                SizedBox(height: 24.h),

                // Card Container wrapping Login Form
                SoftCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
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
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      if (_errorMessage != null) ...[
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: 24.h),

                      // Sign In Button
                      PrimaryButton(
                        label: _isLoading ? 'Signing In...' : 'Sign In',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _isLoading ? null : _handleLogin,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),

                SizedBox(height: 20.h),

                // Link to Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.register);
                      },
                      child: Text(
                        'Sign Up Now',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 350.ms),

                SizedBox(height: 20.h),

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

/// Shared top toggle switcher between Login and Sign Up
class _AuthSegmentedToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onSelectLogin;
  final VoidCallback onSelectRegister;

  const _AuthSegmentedToggle({
    required this.isLogin,
    required this.onSelectLogin,
    required this.onSelectRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isLogin ? null : onSelectLogin,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isLogin ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: isLogin
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      size: 16.sp,
                      color: isLogin ? Colors.white : AppColors.textMuted,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Log In',
                      style: AppTextStyles.button.copyWith(
                        color: isLogin ? Colors.white : AppColors.textMuted,
                        fontSize: 14.sp,
                        fontWeight: isLogin ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: !isLogin ? null : onSelectRegister,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: !isLogin ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: !isLogin
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      size: 16.sp,
                      color: !isLogin ? Colors.white : AppColors.textMuted,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Sign Up',
                      style: AppTextStyles.button.copyWith(
                        color: !isLogin ? Colors.white : AppColors.textMuted,
                        fontSize: 14.sp,
                        fontWeight: !isLogin ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
