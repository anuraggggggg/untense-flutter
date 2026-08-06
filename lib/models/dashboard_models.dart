/// Lightweight expert card data for dashboard lists.
class ExpertSummary {
  const ExpertSummary({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.sessions,
    required this.tags,
    required this.available,
  });

  final String id;
  final String name;
  final String role;
  final double rating;
  final int sessions;
  final List<String> tags;
  final bool available;
}

/// Upcoming / past session summary.
class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.expertName,
    required this.role,
    required this.mode,
    required this.whenLabel,
    required this.status,
  });

  final String id;
  final String expertName;
  final String role;
  final SessionMode mode;
  final String whenLabel;
  final SessionStatus status;
}

enum SessionMode { chat, audio, video }

enum SessionStatus { upcoming, completed, cancelled }

extension SessionModeX on SessionMode {
  String get label => switch (this) {
        SessionMode.chat => 'Chat',
        SessionMode.audio => 'Audio',
        SessionMode.video => 'Video',
      };
}

/// Static demo content until APIs are wired.
abstract final class DashboardContent {
  static const List<ExpertSummary> featuredExperts = [
    ExpertSummary(
      id: '1',
      name: 'Dr. Maya Rao',
      role: 'Clinical Psychologist',
      rating: 4.9,
      sessions: 320,
      tags: ['Anxiety', 'Burnout'],
      available: true,
    ),
    ExpertSummary(
      id: '2',
      name: 'Alex Chen',
      role: 'Career Coach',
      rating: 4.8,
      sessions: 210,
      tags: ['Career', 'Confidence'],
      available: true,
    ),
    ExpertSummary(
      id: '3',
      name: 'Priya Sharma',
      role: 'Therapist',
      rating: 4.9,
      sessions: 410,
      tags: ['Relationships', 'Self-worth'],
      available: false,
    ),
    ExpertSummary(
      id: '4',
      name: 'Jordan Lee',
      role: 'Life Mentor',
      rating: 4.7,
      sessions: 180,
      tags: ['Purpose', 'Habits'],
      available: true,
    ),
  ];

  static const List<SessionSummary> sessions = [
    SessionSummary(
      id: 's1',
      expertName: 'Dr. Maya Rao',
      role: 'Clinical Psychologist',
      mode: SessionMode.video,
      whenLabel: 'Today · 5:30 PM',
      status: SessionStatus.upcoming,
    ),
    SessionSummary(
      id: 's2',
      expertName: 'Alex Chen',
      role: 'Career Coach',
      mode: SessionMode.audio,
      whenLabel: 'Tomorrow · 11:00 AM',
      status: SessionStatus.upcoming,
    ),
    SessionSummary(
      id: 's3',
      expertName: 'Priya Sharma',
      role: 'Therapist',
      mode: SessionMode.chat,
      whenLabel: 'Mon · Completed',
      status: SessionStatus.completed,
    ),
  ];
}
