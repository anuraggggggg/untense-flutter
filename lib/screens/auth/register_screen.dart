import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_notifications.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isSendingOtp = false;
  int _otpTimerSeconds = 0;
  Timer? _timer;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _errorMessage;
  List<String> _fieldErrors = [];
  String? _successMessage;

  @override
  void dispose() {
    _timer?.cancel();
    _fullNameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startOtpTimer() {
    _timer?.cancel();
    setState(() {
      _otpTimerSeconds = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpTimerSeconds > 0) {
        if (mounted) {
          setState(() {
            _otpTimerSeconds--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your email address first to receive OTP.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid email address.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSendingOtp = true;
    });

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.sendOtp(email: email, purpose: 'REGISTER');

    if (!mounted) return;

    setState(() {
      _isSendingOtp = false;
    });

    if (result.success) {
      _startOtpTimer();
      AppNotifications.showSuccessSnackBar(
        context,
        'Verification OTP sent to $email. Please check your inbox.',
      );
    } else {
      AppNotifications.showErrorBottomSheet(
        context: context,
        title: 'OTP Request Failed',
        message: result.message,
        fieldErrors: result.fieldErrors,
      );
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least 1 uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least 1 lowercase letter (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least 1 number (0-9)';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>\-_=+]').hasMatch(value)) {
      return 'Must contain at least 1 special character (!@#\$%^&*)';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _fieldErrors = [];
      _successMessage = null;
    });

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.registerCustomer(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      emailOtp: _otpController.text.trim().isEmpty ? null : _otpController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      setState(() {
        _successMessage = result.message.isNotEmpty
            ? result.message
            : 'Registration successful! Redirecting to Log In...';
      });

      AppNotifications.showSuccessSnackBar(
        context,
        'Account created successfully! Redirecting to sign in...',
      );

      await Future.delayed(const Duration(milliseconds: 1400));
      if (!mounted) return;
      context.go(AppRoutes.auth);
    } else {
      setState(() {
        _errorMessage = result.message;
        _fieldErrors = result.fieldErrors;
      });

      // Renders a professional modal bottom sheet with exact field breakdown
      AppNotifications.showErrorBottomSheet(
        context: context,
        title: 'Registration Unsuccessful',
        message: result.message,
        fieldErrors: result.fieldErrors,
      );
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
                  isLogin: false,
                  onSelectLogin: () => context.go(AppRoutes.auth),
                  onSelectRegister: () {},
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                SizedBox(height: 24.h),

                // Mode Badge Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add_rounded, size: 16.sp, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Text(
                        'NEW CUSTOMER REGISTRATION',
                        style: AppTextStyles.labelSmall.copyWith(
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
                  'Create Your Account',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge,
                ).animate().fadeIn(delay: 200.ms),

                SizedBox(height: 8.h),

                Text(
                  'Sign up as a customer to connect with trusted experts and start feeling lighter.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                ).animate().fadeIn(delay: 250.ms),

                SizedBox(height: 24.h),

                // Registration Form Card
                SoftCard(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _fullNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address';
                            }
                            final emailRegex = RegExp(
                              r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Email OTP Input with Send OTP Action
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Email OTP Code',
                                  prefixIcon: Icon(Icons.mark_email_read_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'OTP is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: OutlinedButton(
                                onPressed: (_isSendingOtp || _otpTimerSeconds > 0)
                                    ? null
                                    : _handleSendOtp,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  minimumSize: Size(100.w, 52.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  side: BorderSide(
                                    color: (_isSendingOtp || _otpTimerSeconds > 0)
                                        ? AppColors.border
                                        : AppColors.primary,
                                  ),
                                ),
                                child: _isSendingOtp
                                    ? SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _otpTimerSeconds > 0
                                            ? '${_otpTimerSeconds}s'
                                            : 'Send OTP',
                                        style: AppTextStyles.labelMedium.copyWith(
                                          color: (_isSendingOtp || _otpTimerSeconds > 0)
                                              ? AppColors.textMuted
                                              : AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number (Optional)',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            helperText:
                                'Min 8 chars with A-Z, a-z, 0-9, and symbol (!@#\$%)',
                            helperMaxLines: 2,
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
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 16.h),

                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        // Professionally formatted inline error banner
                        if (_errorMessage != null) ...[
                          SizedBox(height: 18.h),
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      color: AppColors.error,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.error,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_fieldErrors.isNotEmpty) ...[
                                  SizedBox(height: 8.h),
                                  const Divider(height: 1),
                                  SizedBox(height: 8.h),
                                  ..._fieldErrors.map(
                                    (err) => Padding(
                                      padding: EdgeInsets.only(bottom: 4.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '• ',
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.error,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              err,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],

                        if (_successMessage != null) ...[
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.success,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    _successMessage!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 24.h),

                        // Sign Up / Create Account Button
                        PrimaryButton(
                          label: _isLoading ? 'Creating Account...' : 'Sign Up & Create Account',
                          icon: Icons.person_add_alt_1_rounded,
                          onPressed: _isLoading ? null : _handleRegister,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),

                SizedBox(height: 20.h),

                // Link to Log In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already registered? ',
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.auth);
                      },
                      child: Text(
                        'Log In to Your Account',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 350.ms),

                SizedBox(height: 32.h),
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
