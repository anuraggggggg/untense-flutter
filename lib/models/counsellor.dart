class Counsellor {
  final String id;
  final String fullName;
  final String profileImage;
  final String professionalTitle;
  final int age;
  final String location;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final bool verified;
  final String bio;
  final List<String> languages;
  final List<String> specialities;
  final List<String> qualifications;
  final double chatPrice;
  final double audioPrice;
  final double videoPrice;
  final String sessionDuration;
  final bool availableNow;
  final String nextAvailableSlot;

  const Counsellor({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.professionalTitle,
    required this.age,
    required this.location,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.verified,
    required this.bio,
    required this.languages,
    required this.specialities,
    required this.qualifications,
    required this.chatPrice,
    required this.audioPrice,
    required this.videoPrice,
    required this.sessionDuration,
    required this.availableNow,
    required this.nextAvailableSlot,
  });

  double get startingPrice {
    final prices = [chatPrice, audioPrice, videoPrice].where((p) => p > 0);
    if (prices.isEmpty) return 0;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    return Counsellor(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      profileImage: json['profileImage'] as String? ?? '',
      professionalTitle: json['professionalTitle'] as String,
      age: json['age'] as int? ?? 30,
      location: json['location'] as String,
      experienceYears: json['experienceYears'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      verified: json['verified'] as bool? ?? false,
      bio: json['bio'] as String,
      languages: List<String>.from(json['languages'] as List? ?? []),
      specialities: List<String>.from(json['specialities'] as List? ?? []),
      qualifications: List<String>.from(json['qualifications'] as List? ?? []),
      chatPrice: (json['chatPrice'] as num).toDouble(),
      audioPrice: (json['audioPrice'] as num).toDouble(),
      videoPrice: (json['videoPrice'] as num).toDouble(),
      sessionDuration: json['sessionDuration'] as String? ?? '45 mins',
      availableNow: json['availableNow'] as bool? ?? false,
      nextAvailableSlot: json['nextAvailableSlot'] as String? ?? 'Tomorrow',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profileImage': profileImage,
      'professionalTitle': professionalTitle,
      'age': age,
      'location': location,
      'experienceYears': experienceYears,
      'rating': rating,
      'reviewCount': reviewCount,
      'verified': verified,
      'bio': bio,
      'languages': languages,
      'specialities': specialities,
      'qualifications': qualifications,
      'chatPrice': chatPrice,
      'audioPrice': audioPrice,
      'videoPrice': videoPrice,
      'sessionDuration': sessionDuration,
      'availableNow': availableNow,
      'nextAvailableSlot': nextAvailableSlot,
    };
  }
}
