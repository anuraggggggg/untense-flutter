import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import 'widgets/bottom_nav_bar.dart';

/// Shell hosting Home / Experts / Sessions / Profile with bottom nav.
class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: navigationShell,
        bottomNavigationBar: UnTenseBottomNav(
          navigationShell: navigationShell,
        ),
        extendBody: true,
      ),
    );
  }
}
