import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:untense_app/models/onboarding_page_model.dart';
import 'package:untense_app/providers/onboarding_provider.dart';
import 'package:untense_app/screens/onboarding/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Onboarding shows first page title', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) => child!,
        child: ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),
          child: const MaterialApp(home: OnboardingScreen()),
        ),
      ),
    );

    // Finite pumps — ambient animations loop forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text(OnboardingContent.pages.first.title), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });
}
