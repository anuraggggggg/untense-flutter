/// Content model for a single onboarding page.
class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.illustrationType,
  });

  final String title;
  final String subtitle;
  final OnboardingIllustrationType illustrationType;
}

/// Maps each onboarding page to its custom illustration.
enum OnboardingIllustrationType {
  calmPresence,
  trustedExperts,
  talkYourWay,
}

/// Static onboarding content for UnTense.
abstract final class OnboardingContent {
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: "You're Not Alone",
      subtitle:
          "No matter what you're going through, the right guidance can make all the difference.",
      illustrationType: OnboardingIllustrationType.calmPresence,
    ),
    OnboardingPageModel(
      title: 'Find Trusted Experts',
      subtitle:
          'Connect with psychologists, therapists, career coaches, relationship experts and life mentors.',
      illustrationType: OnboardingIllustrationType.trustedExperts,
    ),
    OnboardingPageModel(
      title: 'Talk Your Way',
      subtitle:
          'Chat, Audio Calls and Video Sessions whenever you need support.',
      illustrationType: OnboardingIllustrationType.talkYourWay,
    ),
  ];
}
