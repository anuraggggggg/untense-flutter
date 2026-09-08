/// API Endpoints and Base URL configuration for UnTense backend services.
abstract final class ApiEndpoints {
  // ── Base URL ───────────────────────────────────────────────
  static const String baseUrl = 'http://65.0.73.114:4001/api/v1';

  // ── Auth Endpoints ─────────────────────────────────────────
  static const String registerCustomer = '/auth/register/customer';
  static const String registerCounsellor = '/auth/register/counsellor';
  static const String login = '/auth/login';
  static const String otpSend = '/auth/otp/send';
  static const String otpVerify = '/auth/otp/verify';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String updateEmail = '/auth/me/email';
  static const String updatePassword = '/auth/me/password';
  static const String updateAvatar = '/auth/me/avatar';

  // ── Customer Endpoints ─────────────────────────────────────
  static const String customerMe = '/customers/me';
  static const String customerFollowing = '/customers/me/following';

  // ── Counsellor Endpoints ───────────────────────────────────
  static const String counsellors = '/counsellors';
  static const String counsellorMe = '/counsellors/me';
  static const String counsellorKyc = '/counsellors/me/kyc';
  static const String counsellorAvailability = '/counsellors/me/availability';
  static const String counsellorFollowers = '/counsellors/me/followers';
  static String counsellorSlots(String id) => '/counsellors/$id/slots';
  static String counsellorFollow(String id) => '/counsellors/$id/follow';

  // ── Category Endpoints ─────────────────────────────────────
  static const String categories = '/categories';
  static const String categoriesManageAll = '/categories/manage/all';
  static String categoryById(String id) => '/categories/$id';
  static String categorySpecialisations(String id) => '/categories/$id/specialisations';
  static String categorySpecialisationById(String id) => '/categories/specialisations/$id';

  // ── Booking Endpoints ──────────────────────────────────────
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String bookingPayWithWallet(String id) => '/bookings/$id/pay-with-wallet';
  static String bookingCancel(String id) => '/bookings/$id/cancel';
  static String bookingReschedule(String id) => '/bookings/$id/reschedule';
  static String bookingNoShow(String id) => '/bookings/$id/no-show';

  // ── Consultation Endpoints ─────────────────────────────────
  static const String consultationWalletStart = '/consultations/wallet/start';
  static String consultationJoin(String id) => '/consultations/$id/join';
  static String consultationLeave(String id) => '/consultations/$id/leave';
  static String consultationEnd(String id) => '/consultations/$id/end';

  // ── Chat Endpoints ─────────────────────────────────────────
  static const String chatThreads = '/chat/threads';
  static String chatThreadMessages(String id) => '/chat/threads/$id/messages';

  // ── Payment Endpoints ──────────────────────────────────────
  static const String paymentOrders = '/payments/orders';
  static const String paymentWebhook = '/payments/webhook';
  static String paymentRefund(String id) => '/payments/$id/refund';

  // ── Review Endpoints ───────────────────────────────────────
  static const String reviews = '/reviews';
  static String reviewsByCounsellor(String id) => '/reviews/counsellor/$id';

  // ── Notification Endpoints ──────────────────────────────────
  static const String notifications = '/notifications';
  static const String deviceTokens = '/notifications/device-tokens';

  // ── File Endpoints ─────────────────────────────────────────
  static const String files = '/files';
  static String fileSignedUrl(String id) => '/files/$id/signed-url';

  // ── Wallet Endpoints ───────────────────────────────────────
  static const String walletMe = '/wallet/me';
  static const String walletTransactions = '/wallet/me/transactions';
  static const String walletTopupOrder = '/wallet/topup/order';
  static const String walletTopupVerify = '/wallet/topup/verify';
  static const String walletSend = '/wallet/send';

  // ── Coupon Endpoints ───────────────────────────────────────
  static const String coupons = '/coupons';
  static const String couponApply = '/coupons/apply';
  static String couponById(String id) => '/coupons/$id';

  // ── Report Endpoints ───────────────────────────────────────
  static const String reports = '/reports';
  static const String reportsMe = '/reports/me';
  static String reportResolve(String id) => '/reports/$id/resolve';

  // ── Admin Endpoints ────────────────────────────────────────
  static const String adminUsers = '/admin/users';
  static const String adminSupport = '/admin/support';
  static String adminKycApprove(String id) => '/admin/kyc/$id/approve';
  static String adminKycReject(String id) => '/admin/kyc/$id/reject';
  static String adminPayoutsApprove(String id) => '/admin/payouts/$id/approve';
  static const String adminAuditLogs = '/admin/audit-logs';
  static String adminWalletById(String id) => '/admin/wallets/$id';
  static String adminWalletTransactions(String id) => '/admin/wallets/$id/transactions';
  static String adminWalletAdjust(String id) => '/admin/wallets/$id/adjust';
  static const String adminWalletTransactionsAll = '/admin/wallet-transactions';
  static const String adminCustomers = '/admin/customers';
  static const String adminCounsellors = '/admin/counsellors';
  static const String adminSupports = '/admin/supports';
  static String adminCounsellorById(String id) => '/admin/counsellors/$id';
  static String adminUserById(String id) => '/admin/users/$id';
  static const String adminKycPending = '/admin/kyc/pending';
  static const String adminKycApproved = '/admin/kyc/approved';
  static const String adminRevenueToday = '/admin/revenue/today';
  static const String adminDashboardStats = '/admin/dashboard/stats';
  static const String adminReviews = '/admin/reviews';
  static String adminReviewById(String id) => '/admin/reviews/$id';

  // ── Agora Config Endpoints ──────────────────────────────────
  static const String adminAgoraConfigs = '/admin/agora-configs';
  static String adminAgoraConfigById(String id) => '/admin/agora-configs/$id';
}
