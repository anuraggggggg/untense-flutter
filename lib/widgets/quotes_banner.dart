import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/quote.dart';
import '../services/quotes_service.dart';

class QuotesBanner extends StatefulWidget {
  const QuotesBanner({super.key});

  @override
  State<QuotesBanner> createState() => _QuotesBannerState();
}

class _QuotesBannerState extends State<QuotesBanner> {
  final QuotesService _service = QuotesService();
  Quote? _quote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final quote = await _service.fetchRandomQuote();
    if (!mounted) return;
    setState(() {
      _quote = quote;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4F1),
        borderRadius: BorderRadius.circular(16.r),
        border: const Border(
          left: BorderSide(
            color: Color(0xFF0D9488),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: _isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Fetching daily inspiration...',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF0D9488),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: const Color(0xFF0D9488),
                  size: 26.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${_quote!.quote}"',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontStyle: FontStyle.italic,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '— ${_quote!.author}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: const Color(0xFF0D9488),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
