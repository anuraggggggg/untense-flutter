import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/onboarding_page_model.dart';
import '../../../widgets/common_widgets.dart';

/// Routes illustration type → visual.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.type,
  });

  final OnboardingIllustrationType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      OnboardingIllustrationType.calmPresence =>
        const _CalmPresenceIllustration(),
      OnboardingIllustrationType.trustedExperts =>
        const _TrustedExpertsIllustration(),
      OnboardingIllustrationType.talkYourWay =>
        const _TalkYourWayIllustration(),
    };
  }
}

// ─────────────────────────────────────────────────────────
// PAGE 1 — Calm human presence
// ─────────────────────────────────────────────────────────

class _CalmPresenceIllustration extends StatelessWidget {
  const _CalmPresenceIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, constraints.maxHeight);
        final showChips = constraints.maxHeight > 240;

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Decorative rings — Positioned so they never expand the Stack.
              Positioned.fill(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(3, (i) {
                        final size = side * (0.55 + i * 0.14);
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.secondary
                                  .withValues(alpha: 0.08 + i * 0.04),
                              width: 1.5,
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: Offset(0.96 + i * 0.01, 0.96 + i * 0.01),
                              end: Offset(1.02 + i * 0.01, 1.02 + i * 0.01),
                              duration: (3200 + i * 400).ms,
                              curve: Curves.easeInOut,
                            );
                      }),
                      CustomPaint(
                        size: Size(side * 0.58, side * 0.64),
                        painter: _CalmProfilePainter(),
                      )
                          .animate()
                          .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                          .scale(
                            begin: const Offset(0.88, 0.88),
                            end: const Offset(1, 1),
                            duration: 800.ms,
                            curve: Curves.easeOutBack,
                          ),
                    ],
                  ),
                ),
              ),
              if (showChips) ...[
                Positioned(
                  top: constraints.maxHeight * 0.08,
                  right: 8.w,
                  child: const _FloatingChip(
                    icon: Icons.favorite_rounded,
                    label: 'Supported',
                    color: AppColors.secondary,
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        delay: 400.ms,
                        duration: 600.ms,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -6, duration: 2800.ms),
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.1,
                  left: 4.w,
                  child: const _FloatingChip(
                    icon: Icons.spa_rounded,
                    label: 'At ease',
                    color: AppColors.primary,
                  )
                      .animate()
                      .fadeIn(delay: 550.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        delay: 550.ms,
                        duration: 600.ms,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -5, duration: 3400.ms),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FloatingChip extends StatelessWidget {
  const _FloatingChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Continuous-line profile inspired by the UnTense logo language.
class _CalmProfilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(3.2, size.width * 0.022)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        Offset(size.width * 0.15, size.height * 0.1),
        Offset(size.width * 0.9, size.height * 0.9),
        [AppColors.primary, AppColors.secondary],
      );

    final path = Path();
    path.moveTo(size.width * 0.38, size.height * 0.28);
    path.cubicTo(
      size.width * 0.18,
      size.height * 0.12,
      size.width * 0.08,
      size.height * 0.32,
      size.width * 0.22,
      size.height * 0.42,
    );
    path.cubicTo(
      size.width * 0.32,
      size.height * 0.48,
      size.width * 0.34,
      size.height * 0.28,
      size.width * 0.42,
      size.height * 0.22,
    );
    path.cubicTo(
      size.width * 0.58,
      size.height * 0.12,
      size.width * 0.78,
      size.height * 0.22,
      size.width * 0.82,
      size.height * 0.38,
    );
    path.cubicTo(
      size.width * 0.86,
      size.height * 0.48,
      size.width * 0.78,
      size.height * 0.55,
      size.width * 0.72,
      size.height * 0.58,
    );
    path.cubicTo(
      size.width * 0.66,
      size.height * 0.62,
      size.width * 0.68,
      size.height * 0.72,
      size.width * 0.62,
      size.height * 0.78,
    );
    path.cubicTo(
      size.width * 0.52,
      size.height * 0.88,
      size.width * 0.35,
      size.height * 0.92,
      size.width * 0.22,
      size.height * 0.86,
    );

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.5, size.height * 0.45),
        size.width * 0.45,
        [
          AppColors.secondary.withValues(alpha: 0.10),
          AppColors.secondary.withValues(alpha: 0.0),
        ],
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.45),
      size.width * 0.42,
      glowPaint,
    );
    canvas.drawPath(path, paint);

    final heartPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, size.width * 0.012)
      ..strokeCap = StrokeCap.round
      ..color = AppColors.secondary.withValues(alpha: 0.55);

    final hx = size.width * 0.48;
    final hy = size.height * 0.48;
    final hs = size.width * 0.08;
    final heart = Path()
      ..moveTo(hx, hy + hs * 0.35)
      ..cubicTo(
        hx - hs,
        hy - hs * 0.2,
        hx - hs * 0.4,
        hy - hs,
        hx,
        hy - hs * 0.35,
      )
      ..cubicTo(
        hx + hs * 0.4,
        hy - hs,
        hx + hs,
        hy - hs * 0.2,
        hx,
        hy + hs * 0.35,
      );
    canvas.drawPath(heart, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────
// PAGE 2 — Trusted expert cards
// ─────────────────────────────────────────────────────────

class _TrustedExpertsIllustration extends StatelessWidget {
  const _TrustedExpertsIllustration();

  static const _experts = [
    _ExpertData(
      'Dr. Maya',
      'Psychologist',
      Icons.psychology_rounded,
      0xFFE8F6F5,
    ),
    _ExpertData(
      'Alex Chen',
      'Career Coach',
      Icons.work_outline_rounded,
      0xFFEEF2F8,
    ),
    _ExpertData(
      'Priya S.',
      'Therapist',
      Icons.favorite_outline_rounded,
      0xFFF5F0EB,
    ),
    _ExpertData(
      'Jordan',
      'Life Mentor',
      Icons.auto_awesome_rounded,
      0xFFEAF7F0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;

        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: math.min(w, h) * 0.75,
                    height: math.min(w, h) * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.10),
                          AppColors.secondary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < _experts.length; i++)
                Positioned.fill(
                  child: Center(
                    child: Transform.translate(
                      offset: _cardOffset(i, w, h),
                      child: Transform.rotate(
                        angle: _cardAngle(i),
                        child: _ExpertCard(data: _experts[i])
                            .animate()
                            .fadeIn(
                              delay: (180 + i * 120).ms,
                              duration: 500.ms,
                            )
                            .slideY(
                              begin: 0.25,
                              end: 0,
                              delay: (180 + i * 120).ms,
                              duration: 550.ms,
                              curve: Curves.easeOutCubic,
                            )
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1, 1),
                              delay: (180 + i * 120).ms,
                              duration: 550.ms,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Offset _cardOffset(int i, double w, double h) {
    final dx = w * 0.18;
    final dy = h * 0.18;
    return switch (i) {
      0 => Offset(-dx, -dy),
      1 => Offset(dx, -dy * 0.55),
      2 => Offset(-dx * 0.75, dy * 0.75),
      _ => Offset(dx * 0.85, dy),
    };
  }

  double _cardAngle(int i) {
    return switch (i) {
      0 => -0.08,
      1 => 0.06,
      2 => 0.05,
      _ => -0.04,
    };
  }
}

class _ExpertData {
  const _ExpertData(this.name, this.role, this.icon, this.bg);

  final String name;
  final String role;
  final IconData icon;
  final int bg;
}

class _ExpertCard extends StatelessWidget {
  const _ExpertCard({required this.data});

  final _ExpertData data;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.all(14.w),
      child: SizedBox(
        width: 120.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Color(data.bg),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(data.icon, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              data.name,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Text(data.role, style: AppTextStyles.labelSmall),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 12.sp,
                  color: AppColors.secondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Verified',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PAGE 3 — Talk your way (chat / audio / video)
// ─────────────────────────────────────────────────────────

class _TalkYourWayIllustration extends StatelessWidget {
  const _TalkYourWayIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, constraints.maxHeight);

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Center(
                  child: CustomPaint(
                    size: Size(side * 0.9, side * 0.9),
                    painter: _ConnectionRingsPainter(),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .rotate(begin: 0, end: 0.04, duration: 8000.ms),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _ModeCard(
                            icon: Icons.chat_bubble_rounded,
                            label: 'Chat',
                            accent: AppColors.secondary,
                            delay: 200,
                          ),
                          SizedBox(width: 14.w),
                          const _ModeCard(
                            icon: Icons.call_rounded,
                            label: 'Audio',
                            accent: AppColors.primary,
                            delay: 320,
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      const _ModeCard(
                        icon: Icons.videocam_rounded,
                        label: 'Video Sessions',
                        accent: AppColors.secondarySoft,
                        delay: 440,
                        wide: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.label,
    required this.accent,
    required this.delay,
    this.wide = false,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final int delay;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.symmetric(
        horizontal: wide ? 28.w : 20.w,
        vertical: 16.h,
      ),
      child: SizedBox(
        width: wide ? 190.w : 104.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.18),
                    accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: accent, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideY(
          begin: 0.2,
          end: 0,
          delay: delay.ms,
          duration: 550.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          delay: delay.ms,
          duration: 550.ms,
        );
  }
}

class _ConnectionRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < 3; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.secondary.withValues(alpha: 0.12 - i * 0.03);
      canvas.drawCircle(center, size.width * (0.28 + i * 0.12), paint);

      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primary.withValues(alpha: 0.08);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: size.width * (0.28 + i * 0.12),
        ),
        i * 0.8,
        math.pi * 0.55,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
