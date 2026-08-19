import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme.dart';
import 'providers/counsellor_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/onboarding_provider.dart';
import 'global/auth_global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const UnTenseApp());
}

class UnTenseApp extends StatelessWidget {
  const UnTenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CounsellorProvider()..fetchCounsellors()),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => child!,
        child: MaterialApp.router(
          title: 'UnTense',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
