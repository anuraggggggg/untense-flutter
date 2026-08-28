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
    this.profileImage = '',
  });

  final String id;
  final String name;
  final String role;
  final double rating;
  final int sessions;
  final List<String> tags;
  final bool available;
  final String profileImage;
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
    this.expertAvatar,
  });

  final String id;
  final String expertName;
  final String role;
  final SessionMode mode;
  final String whenLabel;
  final SessionStatus status;
  final String? expertAvatar;
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
      profileImage:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
    ),
    ExpertSummary(
      id: '2',
      name: 'Alex Chen',
      role: 'Career Coach',
      rating: 4.8,
      sessions: 210,
      tags: ['Career', 'Confidence'],
      available: true,
      profileImage:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=400&q=80',
    ),
    ExpertSummary(
      id: '3',
      name: 'Priya Sharma',
      role: 'Therapist',
      rating: 4.9,
      sessions: 410,
      tags: ['Relationships', 'Self-worth'],
      available: false,
      profileImage:
          'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=400&q=80',
    ),
    ExpertSummary(
      id: '4',
      name: 'Jordan Lee',
      role: 'Life Mentor',
      rating: 4.7,
      sessions: 180,
      tags: ['Purpose', 'Habits'],
      available: true,
      profileImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
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
