import '../models/counsellor.dart';

class CounsellorService {
  static const List<Counsellor> _mockCounsellors = [
    Counsellor(
      id: 'c1',
      fullName: 'Dr. Ananya Sharma',
      profileImage:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Psychologist',
      age: 36,
      location: 'Mumbai, India',
      experienceYears: 10,
      rating: 4.9,
      reviewCount: 142,
      verified: true,
      bio:
          'Specializing in cognitive behavioral therapy (CBT) and anxiety management. Helping individuals navigate stress, burnout, and life transitions with mindfulness and evidence-based techniques.',
      languages: ['English', 'Hindi'],
      specialities: ['Anxiety & Stress', 'CBT', 'Burnout Recovery', 'Mindfulness'],
      qualifications: [
        'Ph.D. in Clinical Psychology (DU)',
        'M.Sc. Applied Psychology',
        'Certified CBT Specialist'
      ],
      chatPrice: 499,
      audioPrice: 799,
      videoPrice: 1199,
      sessionDuration: '45 mins',
      availableNow: true,
      nextAvailableSlot: 'Today, 4:00 PM',
    ),
    Counsellor(
      id: 'c2',
      fullName: 'Rajesh Varma',
      profileImage:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Clinical Psychologist',
      age: 42,
      location: 'Bengaluru, India',
      experienceYears: 14,
      rating: 4.8,
      reviewCount: 98,
      verified: true,
      bio:
          'Dedicated to emotional wellness, trauma-informed care, and depressive disorders. Providing a safe, non-judgmental space for deep healing and personal growth.',
      languages: ['English', 'Kannada', 'Hindi'],
      specialities: ['Depression', 'Trauma Recovery', 'Emotional Regulation'],
      qualifications: [
        'M.Phil. in Clinical Psychology (NIMHANS)',
        'Licensed Clinical Psychologist'
      ],
      chatPrice: 599,
      audioPrice: 899,
      videoPrice: 1399,
      sessionDuration: '50 mins',
      availableNow: false,
      nextAvailableSlot: 'Tomorrow, 10:00 AM',
    ),
    Counsellor(
      id: 'c3',
      fullName: 'Priya Nair',
      profileImage:
          'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Relationship Counsellor',
      age: 34,
      location: 'New Delhi, India',
      experienceYears: 8,
      rating: 4.9,
      reviewCount: 210,
      verified: true,
      bio:
          'Empowering individuals and couples to rebuild trust, improve communication, and resolve conflicts safely.',
      languages: ['English', 'Malayalam', 'Hindi'],
      specialities: ['Relationship Health', 'Conflict Resolution', 'Communication'],
      qualifications: [
        'M.A. Counselling Psychology',
        'Gottman Method Couples Therapy (Level 2)'
      ],
      chatPrice: 450,
      audioPrice: 699,
      videoPrice: 999,
      sessionDuration: '45 mins',
      availableNow: true,
      nextAvailableSlot: 'Today, 6:30 PM',
    ),
    Counsellor(
      id: 'c4',
      fullName: 'Vikram Malhotra',
      profileImage:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Marriage Counsellor',
      age: 45,
      location: 'Pune, India',
      experienceYears: 16,
      rating: 4.7,
      reviewCount: 85,
      verified: true,
      bio:
          'Helping couples navigate marital challenges, intimacy issues, and family dynamics with empathy and structured dialogue.',
      languages: ['English', 'Marathi', 'Hindi'],
      specialities: ['Marriage Guidance', 'Intimacy & Trust', 'Family Dynamics'],
      qualifications: [
        'M.S. Marriage & Family Therapy',
        'Certified Family Counsellor'
      ],
      chatPrice: 600,
      audioPrice: 900,
      videoPrice: 1400,
      sessionDuration: '60 mins',
      availableNow: false,
      nextAvailableSlot: 'Tomorrow, 3:00 PM',
    ),
    Counsellor(
      id: 'c5',
      fullName: 'Sneha Kulkarni',
      profileImage:
          'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Career Counsellor',
      age: 31,
      location: 'Hyderabad, India',
      experienceYears: 6,
      rating: 4.8,
      reviewCount: 64,
      verified: true,
      bio:
          'Assisting young professionals and students in finding purpose, overcoming workplace anxiety, and achieving career alignment.',
      languages: ['English', 'Telugu', 'Hindi'],
      specialities: ['Career Anxiety', 'Work-Life Balance', 'Imposter Syndrome'],
      qualifications: [
        'M.A. Organizational Psychology',
        'Certified Career Practitioner'
      ],
      chatPrice: 399,
      audioPrice: 599,
      videoPrice: 899,
      sessionDuration: '45 mins',
      availableNow: true,
      nextAvailableSlot: 'Today, 5:00 PM',
    ),
    Counsellor(
      id: 'c6',
      fullName: 'David Miller',
      profileImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Therapist',
      age: 39,
      location: 'Kolkata, India',
      experienceYears: 11,
      rating: 4.9,
      reviewCount: 176,
      verified: true,
      bio:
          'Holistic mental wellness practitioner focusing on self-esteem, grief support, and stress reduction through humanistic approaches.',
      languages: ['English', 'Bengali'],
      specialities: ['Grief & Loss', 'Self-Esteem', 'Stress Reduction'],
      qualifications: [
        'M.Sc. Counselling & Guidance',
        'Diploma in Person-Centered Therapy'
      ],
      chatPrice: 499,
      audioPrice: 750,
      videoPrice: 1100,
      sessionDuration: '45 mins',
      availableNow: false,
      nextAvailableSlot: 'Today, 8:00 PM',
    ),
    Counsellor(
      id: 'c7',
      fullName: 'Meera Joshi',
      profileImage:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Life Coach',
      age: 37,
      location: 'Ahmedabad, India',
      experienceYears: 9,
      rating: 4.8,
      reviewCount: 112,
      verified: true,
      bio:
          'Action-oriented coaching to help you clarify goals, build resilience, and unlock your full personal potential.',
      languages: ['English', 'Gujarati', 'Hindi'],
      specialities: ['Goal Setting', 'Personal Growth', 'Resilience'],
      qualifications: [
        'ICF Certified Professional Coach (PCC)',
        'B.A. Psychology'
      ],
      chatPrice: 450,
      audioPrice: 650,
      videoPrice: 950,
      sessionDuration: '45 mins',
      availableNow: true,
      nextAvailableSlot: 'Today, 3:30 PM',
    ),
    Counsellor(
      id: 'c8',
      fullName: 'Dr. Aris Thorne',
      profileImage:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      professionalTitle: 'Cognitive Therapist',
      age: 48,
      location: 'Chennai, India',
      experienceYears: 20,
      rating: 5.0,
      reviewCount: 320,
      verified: true,
      bio:
          'Senior consultant specializing in deep cognitive rest, sleep therapy, and obsessive thought patterns.',
      languages: ['English', 'Tamil'],
      specialities: ['Sleep Therapy', 'OCD & Rumination', 'CBT'],
      qualifications: [
        'Ph.D. in Behavioral Psychology',
        'Senior Fellow of Cognitive Therapy'
      ],
      chatPrice: 799,
      audioPrice: 1199,
      videoPrice: 1799,
      sessionDuration: '60 mins',
      availableNow: false,
      nextAvailableSlot: 'Tomorrow, 11:00 AM',
    ),
  ];

  Future<List<Counsellor>> getCounsellors() async {
    // Simulate network delay for API abstraction readiness
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockCounsellors;
  }

  Future<Counsellor?> getCounsellorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _mockCounsellors.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
