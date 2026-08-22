import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/wallet_transaction.dart';
import '../../providers/wallet_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final currencyFormatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: wallet.balance % 1 == 0 ? 0 : 2,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Wallet', style: AppTextStyles.headlineSmall),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient Balance Card
              _BalanceCard(
                formattedBalance: currencyFormatter.format(wallet.balance),
                onAddMoney: () => _showAddMoneyBottomSheet(context),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1)),
              SizedBox(height: 32.h),
              Text(
                'Transaction History',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 16.h),
              if (wallet.transactions.isEmpty)
                Container(
                  padding: EdgeInsets.all(24.w),
                  alignment: Alignment.center,
                  child: Text(
                    'No transactions yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: wallet.transactions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final tx = wallet.transactions[index];
                    return _TransactionTile(transaction: tx)
                        .animate()
                        .fadeIn(
                          delay: (100 + index * 40).ms,
                          duration: 350.ms,
                        )
                        .slideY(begin: 0.05, end: 0);
                  },
                ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMoneyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddMoneyBottomSheet(),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.formattedBalance,
    required this.onAddMoney,
  });

  final String formattedBalance;
  final VoidCallback onAddMoney;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D9488),
            Color(0xFF14B8A6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            formattedBalance,
            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontSize: 34.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D9488),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              icon: Icon(Icons.add_rounded, size: 20.sp),
              label: Text(
                'Add Money',
                style: AppTextStyles.labelLarge.copyWith(
                  color: const Color(0xFF0D9488),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final formattedAmount = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: transaction.amount % 1 == 0 ? 0 : 2,
    ).format(transaction.amount);

    final isCredit = transaction.isCredit;
    final color = isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final icon = isCredit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final prefix = isCredit ? '+' : '-';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  dateFormat.format(transaction.timestamp),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$prefix$formattedAmount',
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class AddMoneyBottomSheet extends StatefulWidget {
  const AddMoneyBottomSheet({super.key});

  @override
  State<AddMoneyBottomSheet> createState() => _AddMoneyBottomSheetState();
}

class _AddMoneyBottomSheetState extends State<AddMoneyBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<double> _quickAmounts = [100, 200, 500, 1000];
  double? _selectedAmount;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _controller.text = amount.toInt().toString();
    });
  }

  void _handleAddMoney() {
    final enteredText = _controller.text.trim();
    final amount = double.tryParse(enteredText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<WalletProvider>().addMoney(amount);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully added ₹${amount.toInt()} to wallet!'),
        backgroundColor: const Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h + bottomInset),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Add Money to Wallet',
            style: AppTextStyles.headlineSmall,
          ),
          SizedBox(height: 6.h),
          Text(
            'Choose an amount or enter custom value',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: 20.h),

          // Quick Select Chips
          Row(
            children: _quickAmounts.map((amt) {
              final isSelected = _selectedAmount == amt;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: FilterChip(
                    label: Text('₹${amt.toInt()}'),
                    selected: isSelected,
                    onSelected: (_) => _selectQuickAmount(amt),
                    selectedColor: const Color(0xFF0D9488).withValues(alpha: 0.15),
                    checkmarkColor: const Color(0xFF0D9488),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),

          // Custom Input Field
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final parsed = double.tryParse(val);
              setState(() {
                _selectedAmount = parsed;
              });
            },
            decoration: InputDecoration(
              labelText: 'Enter Amount (₹)',
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Proceed Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleAddMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Proceed to Add',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
