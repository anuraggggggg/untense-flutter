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

  void _showForgotPasswordBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ForgotPasswordBottomSheet(
        initialEmail: _emailController.text.trim(),
      ),
    );
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

                      SizedBox(height: 8.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showForgotPasswordBottomSheet,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
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

/// Modal Bottom Sheet for Forgot Password and Reset Password flows
class _ForgotPasswordBottomSheet extends StatefulWidget {
  final String initialEmail;
  const _ForgotPasswordBottomSheet({required this.initialEmail});

  @override
  State<_ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState
    extends State<_ForgotPasswordBottomSheet> {
  int _step = 1; // 1: Request Reset Link, 2: Reset Password with Token
  late final TextEditingController _emailController;
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  String? _infoMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.forgotPassword(email: email);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      setState(() {
        _step = 2;
        _infoMessage = result.message.isNotEmpty
            ? result.message
            : 'If an account exists, a reset token/link was sent to $email.';
      });
    } else {
      setState(() {
        _errorMessage = result.message;
      });
    }
  }

  Future<void> _handleResetPassword() async {
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (token.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the reset token.';
      });
      return;
    }
    if (newPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a new password.';
      });
      return;
    }
    if (newPassword.length < 8) {
      setState(() {
        _errorMessage = 'Password must be at least 8 characters long.';
      });
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.resetPassword(
      token: token,
      newPassword: newPassword,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      Navigator.pop(context);
      AppNotifications.showSuccessSnackBar(
        context,
        'Password reset successfully! Please log in with your new password.',
      );
    } else {
      setState(() {
        _errorMessage = result.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 20.h,
          bottom: MediaQuery.of(context).padding.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                _step == 1 ? 'Reset Password' : 'Enter New Password',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                _step == 1
                    ? 'Enter your account email to receive a password reset token/link.'
                    : 'Enter the reset token received via email along with your new password.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 16.h),

              if (_infoMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _infoMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              if (_errorMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              if (_step == 1) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 20.h),
                PrimaryButton(
                  label: _isLoading ? 'Sending...' : 'Send Reset Link',
                  onPressed: _isLoading ? null : _handleForgotPassword,
                ),
                SizedBox(height: 10.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _step = 2;
                        _errorMessage = null;
                      });
                    },
                    child: Text(
                      'Already have a reset token?',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    labelText: 'Reset Token',
                    prefixIcon: Icon(Icons.key_outlined),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                PrimaryButton(
                  label: _isLoading ? 'Resetting...' : 'Reset Password',
                  onPressed: _isLoading ? null : _handleResetPassword,
                ),
                SizedBox(height: 10.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _step = 1;
                        _errorMessage = null;
                      });
                    },
                    child: Text(
                      'Back to Request Token',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
